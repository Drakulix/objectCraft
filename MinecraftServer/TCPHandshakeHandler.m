//
//  TCPLoginHandler.m
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 04.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "log.h"
#import "TCPHandshakeHandler.h"
#import "TCPClientConnection.h"
#import "TCPHandshake.h"
#import "TCPLoginHandler.h"
#import "TCPStatusHandler.h"

@implementation TCPHandshakeHandler

- (instancetype)initWithClientConnection:(TCPClientConnection *)client {
    self = [super init];
    if (self) {
        connectionDelegate = client;
    }
    return self;
}

- (void)recievedPacket:(TCPPacket *)packet {
    LogVerbose(@"Got Handshake Packet: %@", packet);
    
    if (((TCPHandshake *)packet).nextState == 1) {
        
        [connectionDelegate changeDelegate:[[[TCPStatusHandler alloc] initWithClientConnection:connectionDelegate] autorelease]];
    
    } else if (((TCPHandshake *)packet).nextState == 2) {
        
        [connectionDelegate changeDelegate:[[[TCPLoginHandler alloc] initWithClientConnection:connectionDelegate] autorelease]];
    
    } else {
        
        LogError(@"Unknown Handshake State Value '%llu', kicking Client", ((TCPHandshake *)packet).nextState);
        [connectionDelegate disconnectClient];
    
    }
}

- (void)clientDisconnected {
    
}

- (int)state {
    return 0;
}

@end