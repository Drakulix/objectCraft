//
//  UDPPing.m
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 10.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "UDPPing.h"
#import <time.h>
#include <sys/time.h>

@implementation UDPPing

- (instancetype)init {
    self = [super init];
    if (self) {
        struct timeval time;
        gettimeofday(&time, NULL);
        
        float microtime = 0.0f;
        
        microtime = time.tv_sec;
        microtime += time.tv_usec/1000.0f;
        
        self.clientTime = abs(microtime*1000);
    }
    return self;
}

- (instancetype)initWithData:(NSData *)data {
    self = [super init];
    if (self) {
        NSMutableData *packetData = [data mutableCopy];
        self.clientTime = [packetData readLong];
    }
    return self;
}

+ (uint8_t)packetId {
    return 0x00;
}

- (NSData *)packetData {
    NSMutableData *packetData = [[NSMutableData alloc] init];
    
    [packetData appendLong:self.clientTime];
    
    return packetData;
}

@end
