//
//  TCPLoginHandler.m
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 05.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "log.h"
#import "TCPLoginHandler.h"
#import "TCPClientConnection.h"
#import "TCPLoginStart.h"
#import "TCPLoginSuccess.h"
#import "TCPPlayDelegate.h"

#import "Player.h"

@implementation TCPLoginHandler

- (instancetype)initWithClientConnection:(TCPClientConnection *)client {
    self = [super init];
    if (self) {
        connectionDelegate = client;
    }
    return self;
}

- (void)recievedPacket:(TCPPacket *)packet {
    if ([packet isKindOfClass:[TCPLoginStart class]]) {
        
        LogInfo(@"'%@' connected", ((TCPLoginStart *)packet).username);
        
        TCPLoginSuccess *loginSuccess = [[TCPLoginSuccess alloc] initWithUUID:@"-" Username:((TCPLoginStart *)packet).username];
        [connectionDelegate sendPacket:loginSuccess];
        
        [connectionDelegate changeDelegate:[[[TCPPlayDelegate alloc] initWithClientConnection:connectionDelegate withPlayer:[[Player alloc] initSpawnPlayerWithUsername:((TCPLoginStart *)packet).username]] autorelease]];
        
    }
}

- (void)clientDisconnected {
    
}

- (int)state {
    return 2;
}


@end
