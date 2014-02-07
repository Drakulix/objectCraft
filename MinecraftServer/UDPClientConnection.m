//
//  UDPClientConnection.m
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 09.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#define MIN(a,b) (((a)<(b))?(a):(b))
#import "log.h"
#import "WorldManager.h"
#import "UDPClientConnection.h"
#import "Player.h"

#import "OFDataArray+IntReader.h"

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

#define binarypattern "%d%d%d%d%d%d%d%d"
#define binary(byte)  \
(byte & 0x80 ? 1 : 0), \
(byte & 0x40 ? 1 : 0), \
(byte & 0x20 ? 1 : 0), \
(byte & 0x10 ? 1 : 0), \
(byte & 0x08 ? 1 : 0), \
(byte & 0x04 ? 1 : 0), \
(byte & 0x02 ? 1 : 0), \
(byte & 0x01 ? 1 : 0)

@implementation UDPClientConnection

- (instancetype)initWithPeer:(of_udp_socket_address_t)_peer raknetHandler:(RaknetHandler *)_raknetHandler andMtuSize:(uint64_t)mtu {
    self = [super init];
    @try {
        peer = _peer;
        raknetHandler = [_raknetHandler retain];
        queuedCustomPackets = [[OFMutableDictionary alloc] init];
        queuedMinecraftPackets = [[OFMutableArray alloc] init];
        mtuSize = mtu;
        pePacketCount.i = 0;
        customPacketId.i = 0;
        splitId = 0;
        LogInfo(@"Pocket Edition Connection Established");
    } @catch (id e) {
        [self release];
        @throw e;
    }
    return self;
}

- (void)dealloc {
    //to-do send disconnect packet
    [pingTimer release];
    [raknetHandler release];
    [queuedMinecraftPackets release];
    [queuedCustomPackets release];
    [super dealloc];
}

- (void)recievedMinecraftPacket:(RaknetMinecraftPacket *)data {
    
    OFDataArray *packetData = data.packet;
    uint8_t packetId = [packetData readByte];
    UDPPacket *packet = [UDPPacket packetWithId:packetId data:packetData];
    
    if (!packet)
        LogInfo(@"Got unknown Packet: 0x%02x", packetId);
    //To-Do if all packets are implemented, packet should only be nil, if parsing failed. Send NACK in that case
    
    LogDebug(@"Got MCPE Packet: 0x%02x, %@", packetId, packet);
    
    
    if ([packet isKindOfClass:[UDPPing class]]) {
   
        
        @autoreleasepool {
            [self sendPacket:[[[UDPPong alloc] initWithClientTime:((UDPPing *)packet).clientTime] autorelease]];
        }
        
        
    } else if ([packet isKindOfClass:[UDPClientConnect class]]) {
        
        
        uint16_t port = 0;
        [OFUDPSocket getHost:NULL andPort:&port forAddress:&peer];
        
        @autoreleasepool {
            [self sendPacket:[[[UDPServerHandshake alloc] initWithPort:port sessionId:((UDPClientConnect *)packet).sessionId serverSessionId:0x0000000004440ba9] autorelease]];
            //hardcoded session2? we should test that value
        }
            
        clientId = ((UDPClientConnect *)packet).clientId;
        
        
    } else if ([packet isKindOfClass:[UDPClientHandshake class]]) {
        
        
        @autoreleasepool {
            [self sendPacket:[[[UDPPing alloc] init] autorelease]];
        }
        
        [self flushPackets];
        
        if (!pingTimer)
            pingTimer = [OFTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(sendPing) repeats:YES];
        
        
    } else if ([packet isKindOfClass:[UDPLogin class]]) {
        
        
        //TO-DO
        //Implement Invalid Protocol
        
        @autoreleasepool {
            [self sendPacket:[[[UDPLoginStatus alloc] initWithStatus:0] autorelease]];
        }
        
        if (!player) {
            
            LogInfo(@"'%@' connected!", ((UDPLogin *)packet).username);
            player = [[Player alloc] initSpawnPlayerWithUsername:((UDPLogin *)packet).username];
            player.clientId = clientId;
        
            [self flushPackets];
            
            @autoreleasepool {
                [self sendPacket:[[[UDPStartGame alloc] initWithPlayer:player] autorelease]];
                [self sendPacket:[[[UDPSetTime alloc] initWithDaytime:24000] autorelease]];
            }
            
        }
        
        
    } else if ([packet isKindOfClass:[UDPReadyPacket class]]) {
        
        
        LogDebug(@"Ready Packet Status: %d", ((UDPReadyPacket *)packet).status);
        
        if (((UDPReadyPacket *)packet).status == 1) {
            //nothing to do chunk request packet will follow
        }
        
        if (((UDPReadyPacket *)packet).status == 2) { //Spawn Time!
            @autoreleasepool {
                [self sendPacket:[[[UDPSpawnPosition alloc] initWithPlayer:player] autorelease]];
                [self sendPacket:[[[UDPSetHealth alloc] initWithHealth:1] autorelease]];
            }
        }
        
        
    } else if ([packet isKindOfClass:[UDPChunkRequest class]]) {
        
        
        //TO-DO ChunkData packets are complex and splitted packets, so they are pretty unreliable
        // If the initial sending fails our server still assumes, the chunk has not changed -> chunk error on devices
        //Possible fixes: 1. update LastAgeRequest in Player on ACK Packet for all chunk-data split packets (difficult)
        //                2. Lazy fix, potentially update ageInTicks on all chunk on every tick depending on a random value -> all chunks will get resend/update over time
        
        LogInfo(@"Chunk Request for: %d - %d", ((UDPChunkRequest *)packet).X, ((UDPChunkRequest *)packet).Z);
        uint8_t bitMask = 0x00;
        for (int y = 0; y < 8; y++) {
            if ([player isChunkDirtyAtX:((UDPChunkRequest *)packet).X AtY:y AtZ:((UDPChunkRequest *)packet).Z]) {
                bitMask |= 1 << y;
            }
        }
        
        LogInfo(@"bitmask: "binarypattern, binary(bitMask));
        ChunkColumn *column = [player loadChunkColumnAtX:((UDPChunkRequest *)packet).X AtZ:((UDPChunkRequest *)packet).Z];
        @autoreleasepool {
            [self sendPacket:[[[UDPChunkData alloc] initForChunkColumn:column andBitMask:bitMask] autorelease]];
        }
        
        
    }
    
    [self flushPackets];
}


- (void)ackdCustomPacket:(uint32_t)_customPacketId {
    
    LogVerbose(@"Ackd: %@", [queuedCustomPackets objectForKey:[OFNumber numberWithUInt32:_customPacketId]]);
    [queuedCustomPackets removeObjectForKey:[OFNumber numberWithUInt32:_customPacketId]];
    
}


- (void)nackdCustomPacket:(uint32_t)_customPacketId {

    LogVerbose(@"Nackd: %@", [queuedCustomPackets objectForKey:[OFNumber numberWithUInt32:_customPacketId]]);
    [[queuedCustomPackets objectForKey:[OFNumber numberWithUInt32:_customPacketId]] resend];
    
}


- (BOOL)wasPacketAckd:(uint32_t)_customPacketId {
    return [queuedCustomPackets objectForKey:[OFNumber numberWithUInt32:_customPacketId]] == nil;
}


- (void)sendPacket:(UDPPacket *)packet {
    
    LogDebug(@"Send UDP Packet: %@", packet);
    LogVerbose(@"%@", [packet rawPacketData]);
    
    if ([[packet rawPacketData] count] >= mtuSize - 4) { //custom packet header = 4 bytes
        [self sendLargePacket:packet];
        return;
    }
    
    
    RaknetMinecraftPacket *mcPacket = [[RaknetMinecraftPacket alloc] initReliableWithData:[packet rawPacketData] count:pePacketCount];
    pePacketCount.i++;
    [queuedMinecraftPackets addObject:mcPacket];
    [mcPacket release];
    
}


- (void)flushPackets {

    while ([queuedMinecraftPackets count] > 0) {
            
        int byteCount = 4;//custom packet header = 4 bytes
        OFMutableArray *packets = [[OFMutableArray alloc] init];
        for (RaknetMinecraftPacket *mcPacket in queuedMinecraftPackets) {
            if (byteCount + [mcPacket.packet count] < mtuSize)
                [packets addObject:mcPacket];
        }
        for (RaknetMinecraftPacket *mcPacket in packets) {
            [queuedMinecraftPackets removeObject:mcPacket];
        }
        [self sendMinecraftPackets:packets];
        
    }
    
}

- (void)sendMinecraftPackets:(NSArray *)minecraftPackets {
    
    RaknetCustomPacket *packet = [[RaknetCustomPacket alloc] init];
    [packet setPacketNumber24:customPacketId];
    customPacketId.i++;
    [packet.packets addObjectsFromArray:minecraftPackets];
    [self sendRaknetPacket:packet];
    [packet release];
    
}

- (void)sendLargePacket:(UDPPacket *)packet {
    
    OFDataArray *data = [packet rawPacketData];
    size_t parts = ([data count]/(mtuSize-24)+1); //24 = minecraft and custom packet header
    for (int i=0; i < parts; i++) {
        OFDataArray *subData = [[OFDataArray alloc] initWithCapacity:MIN(mtuSize-24, [data count]-i*(mtuSize-24))];
        [subData addItems:[data itemAtIndex:i*(mtuSize-24)] count:MIN(mtuSize-24, [data count]-i*(mtuSize-24))];
        
        RaknetMinecraftPacket *mcPacket = [[RaknetMinecraftPacket alloc] initSplitPacketWithData:subData count:pePacketCount splitCount:(int32_t)parts splitId:splitId splitIndex:i];
        pePacketCount.i++;
        
        RaknetCustomPacket *raknetPacket = [[RaknetCustomPacket alloc] init];
        [raknetPacket setPacketNumber24:customPacketId];
        customPacketId.i++;
        [raknetPacket.packets addObject:mcPacket];
        
        [self sendRaknetPacket:raknetPacket];
        
        [raknetPacket release];
        [mcPacket release];
    }
    splitId++;
    
}

- (void)sendRaknetPacket:(RaknetCustomPacket *)packet {
    @synchronized (queuedCustomPackets) {
        [queuedCustomPackets setObject:packet forKey:[OFNumber numberWithUInt32:packet.packetNumber]];
        [raknetHandler sendRaknetPacket:packet To:peer];
        [packet dispatchNewTransmissionVia:self];
    }
}

- (void)sendPing {
    @autoreleasepool {
        [self sendPacket:[[[UDPPing alloc] init] autorelease]];
    }
    [self flushPackets];
}

- (uint24_t)nextCustomPacketId {
    uint24_t currentCustomPacketId = customPacketId;
    customPacketId.i++;
    if (customPacketId.i > INT24_MAX)
        customPacketId.i = 0;
    return currentCustomPacketId;
}

- (void)clientDisconnected {
    LogInfo(@"'%@' disconnected", [player username]);
    //to-do send disconnect
    [self flushPackets];
    [pingTimer invalidate];
    [player despawn];
    [player release];
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
