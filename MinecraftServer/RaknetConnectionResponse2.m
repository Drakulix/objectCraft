//
//  RaknetConnectionResponse2.m
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 09.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "RaknetConnectionResponse2.h"
#import "ConfigManager.h"

@implementation RaknetConnectionResponse2

- (instancetype)initWithMtuSize:(int16_t)mtuSize andClientPort:(int16_t)port {
    self = [super init];
    if (self) {
        self.serverId = [ConfigManager sharedInstance].udpServerId;
        self.mtuSize = mtuSize;
        self.clientUDPPort = port;
        self.serverSecurity = 0;
    }
    return self;
}

+ (uint8_t)packetId {
    return 0x08;
}

- (NSData *)packetData {
    NSMutableData *packetData = [[NSMutableData alloc] init];
    
    [packetData appendMagic];
    [packetData appendLong:self.serverId];
    [packetData appendShort:self.clientUDPPort];
    [packetData appendShort:self.mtuSize];
    [packetData appendByte:self.serverSecurity];
    
    return packetData;
}

@end
