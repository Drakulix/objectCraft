//
//  RaknetAdvertise.m
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 08.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "RaknetAdvertise.h"
#import "ConfigManager.h"

@implementation RaknetAdvertise

- (instancetype)initWithPingId:(int64_t)pingId withIndetifier:(NSString *)string {
    self = [super init];
    if (self) {
        self.pingId = pingId;
        self.serverId = [ConfigManager sharedInstance].udpServerId;
        self.identifier = string;
    }
    return self;
}

- (instancetype)initWithData:(NSData *)data {
    self = [super init];
    if (self) {
        NSMutableData *packetData = [data mutableCopy];
        self.pingId = [packetData readLong];
        self.serverId = [packetData readLong];
        if(![packetData checkMagic]) {
            return nil;
        }
        self.identifier = [packetData readStringUdp];
    }
    return self;
}

+ (uint8_t)packetId {
    return 0x1C;
}

- (NSData *)packetData {
    NSMutableData *packetData = [[NSMutableData alloc] init];
    
    [packetData appendLong:self.pingId];
    [packetData appendLong:self.serverId];
    [packetData appendMagic];
    [packetData appendStringUdp:self.identifier];
    
    return packetData;
}


@end
