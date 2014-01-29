//
//  UDPSetHealth.m
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 20.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "UDPSetHealth.h"
#import "OFDataArray+IntReader.h"
#import "OFDataArray+IntWriter.h"

@implementation UDPSetHealth

- (instancetype)initWithHealth:(int8_t)health {
    self = [super init];
    if (self) {
        self.health = health;
    }
    return self;
}

- (instancetype)initWithData:(OFDataArray *)data {
    self = [super init];
    if (self) {
        self.health = [data readByte];
    }
    return self;
}

+ (uint8_t)packetId {
    return 0xaa;
}

- (OFDataArray *)packetData {
    OFDataArray *packetData = [[OFDataArray alloc] init];
    [packetData appendByte:self.health];
    return packetData;
}

@end
