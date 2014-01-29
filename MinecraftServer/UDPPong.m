//
//  UDPPong.m
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 10.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "UDPPong.h"
#import <time.h>
#include <sys/time.h>

@implementation UDPPong

- (instancetype)initWithClientTime:(int64_t)clientTime {
    self = [super init];
    if (self) {
        self.clientTime = clientTime;
        
        struct timeval time;
        gettimeofday(&time, NULL);
        
        float microtime = 0.0f;
        
        microtime = time.tv_sec;
        microtime += time.tv_usec/1000.0f;

        self.serverTime = abs(microtime*1000);
    }
    return self;
}

- (instancetype)initWithData:(NSData *)data {
    self = [super init];
    if (self) {
        NSMutableData *packetData = [data mutableCopy];
        self.clientTime = [packetData readLong];
        self.serverTime = [packetData readLong];
    }
    return self;
}

+ (uint8_t)packetId {
    return 0x03;
}

- (NSData *)packetData {
    NSMutableData *packetData = [[NSMutableData alloc] init];
    [packetData appendLong:self.clientTime];
    [packetData appendLong:self.serverTime];
    return packetData;
}

@end
