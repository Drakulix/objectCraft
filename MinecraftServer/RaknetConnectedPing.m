//
//  RaknetConnectedPing.m
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 08.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "RaknetConnectedPing.h"

@implementation RaknetConnectedPing

- (instancetype)initWithData:(NSData *)data; {
    self = [super init];
    if (self) {
        NSMutableData *packetData = [data mutableCopy];
        self.pingId = [packetData readLong];
        if (![packetData checkMagic]) {
            return nil;
        }
    }
    return self;
}

+ (uint8_t)packetId {
    return 0x01;
}

- (NSData *)packetData {
    NSMutableData *data = [[NSMutableData alloc] init];
    [data appendLong:self.pingId];
    [data appendMagic];
    return data;
}

@end
