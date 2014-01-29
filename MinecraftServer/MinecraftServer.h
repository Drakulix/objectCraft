//
//  MinecraftServer.h
//  MinecraftServer
//
//  Created by Victor Brekenfeld on 22.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import <ObjFW/ObjFW.h>
@class WorldManager;
@class UDPRecieveThread;

@interface MinecraftServer : OFObject<OFApplicationDelegate> {
    BOOL running;
    
    OFTCPSocket *tcpServerSocketIPv4;
    OFTCPSocket *tcpServerSocketIPv6;
    OFMutableArray *activeTCPConnections;
    
    OFUDPSocket *udpServerSocketIPv4;
    UDPRecieveThread *udpServerSocketIPv4Thread;
    OFUDPSocket *udpServerSocketIPv6;
    UDPRecieveThread *udpServerSocketIPv6Thread;
    OFMutableArray *activeUDPConnections;
    
    WorldManager *worldManager;
}

@end
