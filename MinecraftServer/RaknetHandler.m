//
//  RaknetHandler.m
//  MinecraftServer
//
//  Created by Victor Brekenfeld on 28.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "log.h"
#import "RaknetHandler.h"
#import "OFDataArray+IntReader.h"
#import "ConfigManager.h"
#import "UDPClientConnection.h"

#import "RaknetConnectedPing.h"
#import "RaknetAdvertise.h"
#import "RaknetConnectionRequest.h"
#import "RaknetIncompatibleProtocol.h"
#import "RaknetConnectionResponse.h"
#import "RaknetConnectionRequest2.h"
#import "RaknetConnectionResponse2.h"
#import "RaknetCustomPacket.h"
#import "RaknetACK.h"
#import "RaknetNACK.h"
#import <string.h>


@implementation RaknetHandler

static bool udp_socket_address_equal(void *add1, void *add2) {
    return of_udp_socket_address_equal(add1, add2);
}

static uint32_t udp_socket_address_hash(void *add) {
    return of_udp_socket_address_hash(add);
}

static void* udp_retain(void *value)
{
    void *buffer = malloc(sizeof(of_udp_socket_address_t));
    memcpy(buffer, value, sizeof(of_udp_socket_address_t));
    return buffer;
}

static void udp_release(void *value)
{
    free(value);
}

- (instancetype)initWithSocket:(OFUDPSocket *)_socket {
    self = [super init];
    if (self) {
        of_map_table_functions_t udp_socket_func;
        udp_socket_func.equal = udp_socket_address_equal;
        udp_socket_func.hash = udp_socket_address_hash;
        udp_socket_func.retain = udp_retain;
        udp_socket_func.release = udp_release;
        
        of_map_table_functions_t udp_connection_func;
        udp_connection_func.retain = connection_retain;
        udp_connection_func.release = connection_release;
        udp_connection_func.equal = connection_equal;
        udp_connection_func.hash = connection_hash;
        
        openConnections = [[OFMapTable alloc] initWithKeyFunctions:udp_socket_func valueFunctions:udp_connection_func capacity:[ConfigManager defaultManager].maxPlayers];
        socket = _socket;
    }
    return self;
}

- (void)didRecieveData:(OFDataArray *)data fromPeer:(of_udp_socket_address_t)address {
    uint8_t packetId = [data readByte];
    LogVerbose(@"Got Raknet Packet: 0x%02x, %@", packetId, data);
    RaknetPacket *packet = [RaknetPacket packetWithId:packetId data:data];
    if (!packet)
        return;
    
    LogDebug(@"Parsed Raknet Packet: 0x%02x, %@", packetId, packet);
    
    if ([packet isKindOfClass:[RaknetConnectedPing class]]) { //includes UnconnectedPing
        
        
        [self sendRaknetPacket:[[RaknetAdvertise alloc] initWithPingId:((RaknetConnectedPing *)packet).pingId withIndetifier:[OFString stringWithFormat:@"MCCPP;MINECON;%@", [ConfigManager defaultManager].serverBrowserMessage]] To:address];
        
        
    } else if ([packet isKindOfClass:[RaknetConnectionRequest class]]) {
        
        
        if (((RaknetConnectionRequest *)packet).protocolVersion != 5) {
            
            [self sendRaknetPacket:[[RaknetIncompatibleProtocol alloc] init] To:address];
        
        } else {
            
            UDPClientConnection *connection = [openConnections valueForKey:&address];
            if (connection == nil) {
                connection = [[UDPClientConnection alloc] initWithPeer:address raknetHandler:self andMtuSize:((RaknetConnectionRequest *)packet).mtuSize];
                [openConnections setValue:connection forKey:&address];
            }
            
            [self sendRaknetPacket:[[RaknetConnectionResponse alloc] initWithMtuSize:((RaknetConnectionRequest *)packet).mtuSize] To:address];
        }
        
        
    } else if ([packet isKindOfClass:[RaknetConnectionRequest2 class]]) {
        
        
        uint16_t port = 0;
        [OFUDPSocket hostForAddress:&address port:&port];
        
        [self sendRaknetPacket:[[RaknetConnectionResponse2 alloc] initWithMtuSize:((RaknetConnectionRequest2 *)packet).mtuSize andClientPort:port] To:address];
        
        
    } else if ([packet isKindOfClass:[RaknetCustomPacket class]]) {
        
        
        [self sendRaknetPacket:[[RaknetACK alloc] initWithPacketNumber:((RaknetCustomPacket *)packet).packetNumber] To:address];
        
        UDPClientConnection *connection = [openConnections valueForKey:&address];
        for (RaknetMinecraftPacket *mcPacket in ((RaknetCustomPacket *)packet).packets) {
            [connection recievedMinecraftPacket:mcPacket];
        }
        
        
    } else if ([packet isKindOfClass:[RaknetNACK class]]) {
        
        
        UDPClientConnection *connection = [openConnections valueForKey:&address];
        [connection nackdCustomPacket:((RaknetNACK *)packet).packetNumber];
        if (((RaknetNACK *)packet).hasAdditionalPacketNumber) {
            [connection nackdCustomPacket:((RaknetNACK *)packet).additionalPacketNumber];
        }
        
        
    } else if ([packet isKindOfClass:[RaknetACK class]]) {
        
        UDPClientConnection *connection = [openConnections valueForKey:&address];
        [connection ackdCustomPacket:((RaknetACK *)packet).packetNumber];
        if (((RaknetACK *)packet).hasAdditionalPacketNumber) {
            [connection ackdCustomPacket:((RaknetACK *)packet).additionalPacketNumber];
        }
        
    }

}

- (void)sendRaknetPacket:(RaknetPacket *)packet To:(of_udp_socket_address_t)peer {
    
    LogDebug(@"Sending Raknet Packet: %@", packet);
    LogVerbose(@"%@", [packet rawPacketData]);
    OFDataArray *data = [packet rawPacketData];
    [socket sendBuffer:[data firstItem] length:[data count] receiver:&peer];
    
}

- (void)clientHasDisconnected:(of_udp_socket_address_t)peer {
    
    if ([openConnections valueForKey:&peer] != nil && [openConnections valueForKey:&peer] != NULL) {
        UDPClientConnection *connection = [openConnections valueForKey:&peer];
        [connection clientDisconnected];
        [openConnections removeValueForKey:&peer];
    }
    
}

@end
