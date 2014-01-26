//
//  MinecraftServer.h
//  MinecraftServer
//
//  Created by Victor Brekenfeld on 22.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import <ObjFW/ObjFW.h>

@interface MinecraftServer : OFObject<OFApplicationDelegate> {
    BOOL running;
    
    OFTCPSocket *tcpServerSocketIPv4;
    OFTCPSocket *tcpServerSocketIPv6;
    OFMutableArray *activeTCPConnections;
    
    //OFDictionary *worlds; //improve: add world manager class
}

@end
