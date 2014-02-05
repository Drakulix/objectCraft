//
//  MinecraftServer.h
//  MinecraftServer
//
//  Created by Victor Brekenfeld on 22.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import <ObjFW/ObjFW.h>
@class WorldManager;
@class RaknetHandler;
#define UDP_MAX_PACKET_SIZE 1504 //MAX MTU is 1447. 1504 bytes should never be too small

@interface MinecraftServer : OFObject<OFApplicationDelegate> {
    BOOL running;
    
    OFTCPSocket *tcpServerSocketIPv4;
    OFTCPSocket *tcpServerSocketIPv6;
    OFMutableArray *activeTCPConnections;
    
    OFUDPSocket *udpServerSocketIPv4;
    void *udpServerSocketIPv4Buffer;
    OFUDPSocket *udpServerSocketIPv6;
    void *udpServerSocketIPv6Buffer;
    OFMutableArray *activeUDPConnections;
    RaknetHandler  *raknetHandlerIPv4;
    RaknetHandler  *raknetHandlerIPv6;
    
    WorldManager *worldManager;
}

@end
