//
//  UDPClientConnection.h
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 09.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import <ObjFW/ObjFW.h>
#import "int24_t.h"
@class RaknetHandler;
@class RaknetCustomPacket;
@class RaknetMinecraftPacket;
@class Player;

@interface UDPClientConnection : OFObject {
    of_udp_socket_address_t peer;
    RaknetHandler *raknetHandler;
    uint64_t mtuSize;
    
    OFTimer *pingTimer;
    uint24_t customPacketId;
    uint24_t pePacketCount;
    uint16_t splitId;
    
    OFMutableArray *queuedMinecraftPackets;
    OFMutableDictionary *queuedCustomPackets;
    
    long clientId;
    Player *player;
    
    OFMutableSet *loadedChunks;
}

- (instancetype)initWithPeer:(of_udp_socket_address_t)peer raknetHandler:(RaknetHandler *)raknetHandler andMtuSize:(uint64_t)mtu;

- (void)recievedMinecraftPacket:(RaknetMinecraftPacket *)data;
- (void)ackdCustomPacket:(uint32_t)customPacketId;
- (void)nackdCustomPacket:(uint32_t)customPacketId;
- (BOOL)wasPacketAckd:(uint32_t)customPacketId;

- (uint24_t)nextCustomPacketId;
- (void)sendRaknetPacket:(RaknetCustomPacket *)packet;

- (void)clientDisconnected;

@end

void *connection_retain(void *value);
void connection_release(void *value);
uint32_t connection_hash(void *value);
bool connection_equal(void *value1, void *value2);