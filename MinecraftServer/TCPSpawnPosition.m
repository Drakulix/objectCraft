//
//  TCPSpawnPosition.m
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 06.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "TCPSpawnPosition.h"
#import "OFDataArray+IntWriter.h"

@implementation TCPSpawnPosition
@synthesize X, Y, Z;

- (instancetype)initWithX:(int32_t)x withY:(int32_t)y withZ:(int32_t)z {
    self = [super init];
    @try {
        self.X = x;
        self.Y = y;
        self.Z = z;
    } @catch (id e) {
        [self release];
        @throw e;
    }
    return self;
}

+ (uint64_t)packetId {
    return 0x05;
}

- (OFDataArray *)packetData {
    OFDataArray *packetData = [OFDataArray dataArray];
    [packetData appendInt:self.X];
    [packetData appendInt:self.Y];
    [packetData appendInt:self.Z];
    return packetData;
}

@end
