//
//  TCPStatusPong.m
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 10.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "TCPStatusPong.h"
#import "OFDataArray+IntWriter.h"

@implementation TCPStatusPong

- (instancetype)initWithTime:(int64_t)time {
    self = [super init];
    if (self) {
        self.time = time;
    }
    return self;
}

+ (int)state {
    return 1;
}

+ (uint64_t)packetId {
    return 0x01;
}

- (OFDataArray *)packetData {
    OFDataArray *packetData = [[OFDataArray alloc] init];
    [packetData appendLong:self.time];
    return packetData;
}

@end
