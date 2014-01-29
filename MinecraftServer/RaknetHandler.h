//
//  RaknetHandler.h
//  MinecraftServer
//
//  Created by Victor Brekenfeld on 28.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import <ObjFW/ObjFW.h>
@class RaknetPacket;

@interface RaknetHandler : OFObject {
    @private
    OFUDPSocket *socket;
    OFMapTable *openConnections;
}

- (instancetype)initWithSocket:(OFUDPSocket *)socket;
- (void)didRecieveData:(OFDataArray *)data fromPeer:(of_udp_socket_address_t)address;
- (void)sendRaknetPacket:(RaknetPacket *)packet To:(of_udp_socket_address_t)peer;
- (void)clientHasDisconnected:(of_udp_socket_address_t)peer;

@end
