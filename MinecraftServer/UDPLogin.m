//
//  UDPLoginPacket.m
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 09.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "UDPLogin.h"

@implementation UDPLogin

- (instancetype)initWithData:(NSData *)data {
    self = [super init];
    if (self) {
        NSMutableData *packetData = [data mutableCopy];
        self.username = [packetData readStringUdp];
        self.protocol1 = [packetData readInt];
        self.protocol2 = [packetData readInt];
        self.clientId = [packetData readInt];
        self.realmsData = [packetData readStringUdp];
    }
    return self;
}

+ (uint8_t)packetId {
    return 0x82;
}

- (NSData *)packetData {
    NSMutableData *packetData = [[NSMutableData alloc] init];
    
    [packetData appendStringUdp:self.username];
    [packetData appendInt:self.protocol1];
    [packetData appendInt:self.protocol2];
    [packetData appendInt:self.clientId];
    [packetData appendStringUdp:self.realmsData];
    
    return packetData;
}

@end
