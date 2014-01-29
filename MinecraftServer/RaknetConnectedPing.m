//
//  RaknetConnectedPing.m
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 08.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "RaknetConnectedPing.h"
#import "OFDataArray+IntReader.h"
#import "OFDataArray+IntWriter.h"
#import "OFDataArray+RaknetMagic.h"

@implementation RaknetConnectedPing

- (instancetype)initWithData:(OFDataArray *)data; {
    self = [super init];
    if (self) {
        self.pingId = [data readLong];
        if (![data checkMagic]) {
            return nil;
        }
    }
    return self;
}

+ (uint8_t)packetId {
    return 0x01;
}

- (OFDataArray *)packetData {
    OFDataArray *data = [[OFDataArray alloc] init];
    [data appendLong:self.pingId];
    [data appendMagic];
    return data;
}

@end
