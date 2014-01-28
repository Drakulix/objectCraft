//
//  RaknetConnectionRequest.m
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 08.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "RaknetConnectionRequest.h"

@implementation RaknetConnectionRequest

- (instancetype)initWithData:(NSData *)data {
    self = [super init];
    if (self) {
        NSMutableData *packetData = [data mutableCopy];
        if (![packetData checkMagic]) {
            return nil;
        }
        self.protocolVersion = [packetData readByte];
        self.mtuSize = [packetData length];
    }
    return self;
}

+ (uint8_t)packetId {
    return 0x05;
}

- (NSData *)packetData {
    NSMutableData *packetData = [[NSMutableData alloc] init];
    [packetData appendMagic];
    [packetData appendByte:self.protocolVersion];
    for (int i = 0; i<self.mtuSize; i++) {
        [packetData appendByte:0x00];
    }
    return packetData;
}

@end
