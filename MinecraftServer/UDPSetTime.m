//
//  UDPSetTime.m
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 17.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "UDPSetTime.h"
#import "OFDataArray+IntReader.h"
#import "OFDataArray+IntWriter.h"

@implementation UDPSetTime

- (instancetype)initWithDaytime:(int32_t)time {
    self = [super init];
    if (self) {
        self.time = time;
    }
    return self;
}

- (instancetype)initWithData:(OFDataArray *)data {
    self = [super init];
    if (self) {
        self.time = [data readInt];
    }
    return self;
}

+ (uint8_t)packetId {
    return 0x86;
}

- (OFDataArray *)packetData {
    OFDataArray *packetData = [[OFDataArray alloc] init];
    
    [packetData appendInt:self.time];
    
    return packetData;
}

@end
