//
//  TCPTimeUpdate.m
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 07.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "TCPTimeUpdate.h"
#import "OFDataArray+IntWriter.h"

@implementation TCPTimeUpdate

- (instancetype)initWithAge:(int64_t)age andDayTime:(int64_t)time {
    self = [super init];
    @try {
        self.ageOfWorld = age;
        self.timeOfDay = time;
    } @catch (id e) {
        [self release];
        @throw e;
    }
    return self;
}

+ (uint64_t)packetId {
    return 0x03;
}

- (OFDataArray *)packetData {
    OFDataArray *packetData = [OFDataArray dataArray];
    [packetData appendLong:self.ageOfWorld];
    [packetData appendLong:self.timeOfDay];
    return packetData;
}

@end