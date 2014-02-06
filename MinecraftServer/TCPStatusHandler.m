//
//  TCPStatusHandler.m
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 05.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "log.h"
#import "TCPStatusHandler.h"
#import "TCPClientConnection.h"
#import "TCPStatusRequest.h"
#import "TCPStatusResponse.h"
#import "TCPStatusPing.h"
#import "TCPStatusPong.h"
#import "ConfigManager.h"
#import "Player.h"

@implementation TCPStatusHandler

- (instancetype)initWithClientConnection:(TCPClientConnection *)client {
    self = [super init];
    @try {
        connectionDelegate = [client retain];
    }
    @catch (id e) {
        [self release]
        @throw e;
    }
    return self;
}

- (void)recievedPacket:(TCPPacket *)packet {
    LogVerbose(@"Got Status Packet: %@", packet);
    if ([packet isMemberOfClass:[TCPStatusRequest class]]) {
        @autoreleasepool {
            OFDictionary *infos = [OFDictionary dictionaryWithKeysAndObjects:
                                   @"version", [OFDictionary dictionaryWithKeysAndObjects:
                                                @"name", @"1.7.4",
                                                @"protocol", [OFNumber numberWithInt:4]
                                                , nil],
                                   @"players", [OFDictionary dictionaryWithKeysAndObjects:
                                                @"max", [OFNumber numberWithInt:[ConfigManager defaultManager].maxPlayers],
                                                @"online", [OFNumber numberWithInt32:[Player playerCount]]
                                                , nil],
                                   @"description", [OFDictionary dictionaryWithKeysAndObjects:
                                                    @"text", [ConfigManager defaultManager].serverBrowserMessage
                                                    , nil]
                                   , nil];
            [connectionDelegate sendPacket:[[[TCPStatusResponse alloc] initWithDictionary:infos] autorelease]];
        }
    } else if ([packet isMemberOfClass:[TCPStatusPing class]]) {
        @autoreleasepool {
            [connectionDelegate sendPacket:[[[TCPStatusPong alloc] initWithTime:((TCPStatusPing *)packet).time] autorelease]];
        }
    }
}

- (void)clientDisconnected {
    
}

- (int)state {
    return 1;
}

- (void)dealloc {
    [connectionDelegate release];
    [super dealloc];
}

@end
