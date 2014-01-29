//
//  UDPClientConnect.m
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 09.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "UDPClientConnect.h"

@implementation UDPClientConnect

- (instancetype)initWithData:(NSData *)data {
    self = [super init];
    if (self) {
        NSMutableData *packetData = [data mutableCopy];
        self.clientId = [packetData readLong];
        self.sessionId = [packetData readLong];
        self.unknown = [packetData readByte];
    }
    return self;
}

+ (uint8_t)packetId {
    return 0x09;
}

- (NSData *)packetData {
    NSMutableData *packetData = [[NSMutableData alloc] init];
    [packetData appendLong:self.clientId];
    [packetData appendLong:self.sessionId];
    [packetData appendByte:self.unknown];
    return packetData;
}

@end
