//
//  UDPClientConnection.m
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 09.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "MinecraftServer.h"
#import "UDPClientConnection.h"
#import "RaknetHandler.h"
#import "RaknetMinecraftPacket.h"
#import "RaknetCustomPacket.h"
#import "UDPPacket.h"
#import "UDPLogin.h"
#import "UDPClientConnect.h"
#import "UDPServerHandshake.h"
#import "UDPClientHandshake.h"
#import "UDPLoginStatus.h"
#import "UDPPing.h"
#import "UDPPong.h"
#import "UDPStartGame.h"
#import "UDPSpawnPosition.h"
#import "UDPSetTime.h"
#import "UDPReadyPacket.h"
#import "UDPChunkRequest.h"
#import "UDPChunkData.h"
#import "UDPSetHealth.h"
#import "UDPAddPlayer.h"
#import "UDPMoveEntity_PosRot.h"

@implementation UDPClientConnection
@dynamic queuedPackets;

- (instancetype)initWithPeer:(NSData *)_peer raknetHandler:(RaknetHandler *)_raknetHandler andMtuSize:(uint64_t)mtu {
    self = [super init];
    if (self) {
        peer = _peer;
        raknetHandler = _raknetHandler;
        queuedCustomPackets = [[NSMutableDictionary alloc] init];
        queuedMinecraftPackets = [[NSMutableArray alloc] init];
        mtuSize = mtu;
        pePacketCount.i = 0;
        customPacketId.i = 0;
        splitId = 0;
        NSLogInfo(@"Pocket Edition Connection Established");
    }
    return self;
}

- (void)recievedMinecraftPacket:(RaknetMinecraftPacket *)data {
    
    NSMutableData *packetData = [data.packet mutableCopy];
    uint8_t packetId = [packetData readByte];
    UDPPacket *packet = [UDPPacket packetWithId:packetId data:packetData];
    
    if (!packet)
        NSLogInfo(@"Got unknown Packet: 0x%02x", packetId);
    
    NSLogDebug(@"Got MCPE Packet: 0x%02x, %@", packetId, packet);
    
    if ([packet isKindOfClass:[UDPPing class]]) {
   
        [self sendPacket:[[UDPPong alloc] initWithClientTime:((UDPPing *)packet).clientTime]];
        
    } else if ([packet isKindOfClass:[UDPClientConnect class]]) {
        
        uint16_t port = 0;
        [GCDAsyncUdpSocket getHost:nil port:&port family:NULL fromAddress:peer];
        [self sendPacket:[[UDPServerHandshake alloc] initWithPort:port sessionId:((UDPClientConnect *)packet).sessionId serverSessionId:0x0000000004440ba9]]; //hardcoded session2? we should test that
        clientId = ((UDPClientConnect *)packet).clientId;
        
    } else if ([packet isKindOfClass:[UDPClientHandshake class]]) {
        
        [self sendPacket:[[UDPPing alloc] init]];
        [self flushPackets];
        [self sendPing];
        
    } else if ([packet isKindOfClass:[UDPLogin class]]) {
        
        [self sendPacket:[[UDPLoginStatus alloc] initWithStatus:0]];
        
        if (!player) {
            NSLogInfo(@"'%@' connected!", ((UDPLogin *)packet).username);
            player = [[Player alloc] initSpawnPlayerWithUsername:((UDPLogin *)packet).username];
            player.clientId = clientId;
        
            [self flushPackets];
            [self sendPacket:[[UDPStartGame alloc] initWithPlayer:player]];
            [self sendPacket:[[UDPSetTime alloc] initWithDaytime:24000]];
            
        }
    } else if ([packet isKindOfClass:[UDPReadyPacket class]]) {
        NSLogDebug(@"Ready Packet Status: %d", ((UDPReadyPacket *)packet).status);
        if (((UDPReadyPacket *)packet).status == 1) {
            //nothing to do chunk request follows
        }
        if (((UDPReadyPacket *)packet).status == 2) { //Spawn Time Bitches
            [self sendPacket:[[UDPSpawnPosition alloc] initWithPlayer:player]];
            [self sendPacket:[[UDPSetHealth alloc] initWithHealth:1]];
        }
        /*[self sendPacket:[[UDPMoveEntity_PosRot alloc] initWithPlayer:player]];
        [self sendPacket:[[UDPSetHealth alloc] initWithHealth:1]];
        [self sendPacket:[[UDPSetTime alloc] initWithDaytime:6000]];
        [self flushPackets];
        
        [self sendPacket:[[UDPChunkData alloc] init]];*/
    
    } else if ([packet isKindOfClass:[UDPChunkRequest class]]) {
        [self sendPacket:[[UDPChunkData alloc] initForChunkColumn:[[[MinecraftServer sharedInstance] worldForDimension:player.dimension] chunkColumnForPositionX:((UDPChunkRequest *)packet).X Z:((UDPChunkRequest *)packet).Z]]];
    }
    
    
    
    [self flushPackets];
}

- (void)ackdCustomPacket:(uint32_t)_customPacketId {
    NSLogVerbose(@"Ackd: %@", [self.queuedPackets objectForKey:@(_customPacketId)]);
    @synchronized (queuedCustomPackets) {
        [queuedCustomPackets removeObjectForKey:@(_customPacketId)];
    }
}

- (void)nackdCustomPacket:(uint32_t)_customPacketId {
    NSLogVerbose(@"Nackd: %@", [self.queuedPackets objectForKey:@(_customPacketId)]);
}

- (void)sendPacket:(UDPPacket *)packet {
    NSLogDebug(@"Send UDP Packet: %@", packet);
    NSLogVerbose(@"%@", [packet rawPacketData]);
    
    if ([[packet rawPacketData] length] >= mtuSize - 4) { //custom packet header = 4 bytes
        [self sendLargePacket:packet];
        return;
    }
    
    RaknetMinecraftPacket *mcPacket = [[RaknetMinecraftPacket alloc] initReliableWithData:[packet rawPacketData] count:pePacketCount];
    pePacketCount.i++;
    @synchronized (queuedMinecraftPackets) {
        [queuedMinecraftPackets addObject:mcPacket];
    }
}

- (void)flushPackets {
    @synchronized (queuedMinecraftPackets) {
        while ([queuedMinecraftPackets count] > 0) {
            
            int byteCount = 4;//custom packet header = 4 bytes
            NSMutableArray *packets = [[NSMutableArray alloc] init];
            for (RaknetMinecraftPacket *mcPacket in queuedMinecraftPackets) {
                if (byteCount + [mcPacket.packet length] < mtuSize)
                    [packets addObject:mcPacket];
            }
            [queuedMinecraftPackets removeObjectsInArray:packets];
            
            [self sendMinecraftPackets:packets];
            [queuedMinecraftPackets removeAllObjects];
        }
    }
}

- (void)sendMinecraftPackets:(NSArray *)minecraftPackets {
    RaknetCustomPacket *packet = [[RaknetCustomPacket alloc] init];
    [packet setPacketNumber24:customPacketId];
    customPacketId.i++;
    [packet.packets addObjectsFromArray:minecraftPackets];
    [self sendRaknetPacket:packet];
}

- (void)sendLargePacket:(UDPPacket *)packet {
    NSData *data = [packet rawPacketData];
    NSUInteger parts = ([data length]/(mtuSize-24)+1); //24 = minecraft and custom packet header
    for (int i=0; i<parts; i++) {
        RaknetMinecraftPacket *mcPacket = [[RaknetMinecraftPacket alloc] initSplitPacketWithData:[data subdataWithRange:NSMakeRange(i*(mtuSize-24), MIN(mtuSize-24, [data length]-i*(mtuSize-24)))] count:pePacketCount splitCount:(int32_t)parts splitId:splitId splitIndex:i];
        pePacketCount.i++;
        
        RaknetCustomPacket *raknetPacket = [[RaknetCustomPacket alloc] init];
        [raknetPacket setPacketNumber24:customPacketId];
        customPacketId.i++;
        [raknetPacket.packets addObject:mcPacket];
        
        [self sendRaknetPacket:raknetPacket];
    }
    splitId++;
}

- (void)sendRaknetPacket:(RaknetCustomPacket *)packet {
    @synchronized (queuedCustomPackets) {
        [queuedCustomPackets setObject:packet forKey:@(packet.packetNumber)];
        [raknetHandler sendRaknetPacket:packet To:peer];
        [packet dispatchNewTransmissionVia:self];
    }
}

- (void)sendPing {
    double delayInSeconds = 0.1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void){
        [self sendPacket:[[UDPPing alloc] init]];
        [self flushPackets];
        [self performSelector:@selector(sendPing) withObject:nil afterDelay:1.0];
    });
}

- (uint24_t)nextCustomPacketId {
    uint24_t currentCustomPacketId = customPacketId;
    customPacketId.i++;
    if (customPacketId.i > INT24_MAX)
        customPacketId.i = 0;
    return currentCustomPacketId;
}

- (NSMutableDictionary *)queuedPackets {
    return queuedCustomPackets;
}

- (void)clientDisconnected {
    NSLogInfo(@"'%@' disconnected", [player username]);
    [player despawn];
}

@end

void* connection_retain(void *value)
{
    return [(id)value retain];
}

void connection_release(void *value)
{
    [(id)value release];
}

uint32_t connection_hash(void *value)
{
    return [(id)value hash];
}

bool connection_equal(void *value1, void *value2)
{
    return [(id)value1 isEqual: (id)value2];
}
