//
//  RaknetConnectionResponse.m
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 08.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "RaknetConnectionResponse.h"
#import "ConfigManager.h"

@implementation RaknetConnectionResponse

- (instancetype)initWithMtuSize:(int16_t)mtuSize {
    self = [super init];
    if (self) {
        self.serverId = [ConfigManager sharedInstance].udpServerId;
        self.serverSecurity = 0;
        self.mtuSize = mtuSize;
    }
    return self;
}

- (instancetype)initWithData:(NSData *)data {
    self = [super init];
    if (self) {
        NSMutableData *packetData = [data mutableCopy];
        if (![packetData checkMagic]) {
            return nil;
        }
        self.serverId = [packetData readLong];
        self.serverSecurity = [packetData readByte];
        self.mtuSize = [packetData readShort];
    }
    return self;
}

+ (uint8_t)packetId {
    return 0x06;
}

- (NSData *)packetData {
    NSMutableData *packetData = [[NSMutableData alloc] init];
    
    [packetData appendMagic];
    [packetData appendLong:self.serverId];
    [packetData appendByte:self.serverSecurity];
    [packetData appendShort:self.mtuSize];
    
    return packetData;
}

@end
