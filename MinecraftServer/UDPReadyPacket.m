//
//  UDPReadyPacket.m
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 20.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "UDPReadyPacket.h"
#import "OFDataArray+IntReader.h"
#import "OFDataArray+IntWriter.h"

@implementation UDPReadyPacket

- (instancetype)initWithStatus:(int8_t)status {
    self = [super init];
    if (self) {
        self.status = status;
    }
    return self;
}

- (instancetype)initWithData:(OFDataArray *)data {
    self = [super init];
    if (self) {
        self.status = [data readByte];
    }
    return self;
}

+ (uint8_t)packetId {
    return 0x84;
}

- (OFDataArray *)packetData {
    OFDataArray *packetData = [[OFDataArray alloc] init];
    [packetData appendByte:self.status];
    return packetData;
}

@end
