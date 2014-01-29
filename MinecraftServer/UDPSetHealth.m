//
//  UDPSetHealth.m
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 20.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "UDPSetHealth.h"

@implementation UDPSetHealth

- (instancetype)initWithHealth:(int8_t)health {
    self = [super init];
    if (self) {
        self.health = health;
    }
    return self;
}

- (instancetype)initWithData:(NSData *)data {
    self = [super init];
    if (self) {
        NSMutableData *packetData = [data mutableCopy];
        self.health = [packetData readByte];
    }
    return self;
}

+ (uint8_t)packetId {
    return 0xaa;
}

- (NSData *)packetData {
    NSMutableData *packetData = [[NSMutableData alloc] init];
    [packetData appendByte:self.health];
    return packetData;
}

@end
