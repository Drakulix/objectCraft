//
//  RaknetConnectionRequest2.m
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 09.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "RaknetConnectionRequest2.h"

@implementation RaknetConnectionRequest2

- (instancetype)initWithData:(NSData *)data {
    self = [super init];
    if (self) {
        NSMutableData *packetData = [data mutableCopy];
        if (![packetData checkMagic])
            return nil;
        self.clientSecurity = [packetData readByte];
        self.cookie = [packetData readInt];
        self.serverUDPPort = [packetData readShort];
        self.mtuSize = [packetData readShort];
        self.clientId = [packetData readLong];
    }
    return self;
}

+ (uint8_t)packetId {
    return 0x07;
}

- (NSData *)packetData {
    NSMutableData *packetData = [[NSMutableData alloc] init];
    [packetData appendMagic];
    [packetData appendByte:self.clientSecurity];
    [packetData appendInt:self.cookie];
    [packetData appendShort:self.serverUDPPort];
    [packetData appendShort:self.mtuSize];
    [packetData appendLong:self.clientId];
    return packetData;
}

@end
