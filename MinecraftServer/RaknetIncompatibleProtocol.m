//
//  RaknetIncompatibleProtocol.m
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 09.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "RaknetIncompatibleProtocol.h"
#import "ConfigManager.h"

@implementation RaknetIncompatibleProtocol

- (id)init {
    self = [super init];
    if (self) {
        self.protocolVersion = 5;
        self.serverId = [ConfigManager sharedInstance].udpServerId;
    }
    return self;
}

- (id)initWithData:(NSData *)data {
    self = [super init];
    if (self) {
        NSMutableData *packetData = [data mutableCopy];
        self.protocolVersion = [packetData readByte];
        if (![packetData checkMagic]) {
            return nil;
        }
        self.serverId = [packetData readLong];
    }
    return self;
}

+ (uint8_t)packetId {
    return 0x1a;
}

- (NSData *)packetData {
    NSMutableData *packetData = [[NSMutableData alloc] init];
    
    [packetData appendByte:self.protocolVersion];
    [packetData appendMagic];
    [packetData appendLong:self.serverId];
    
    return packetData;
}

@end
