//
//  RaknetConnectionRequest.m
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 08.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "RaknetConnectionRequest.h"
#import "OFDataArray+IntReader.h"
#import "OFDataArray+IntWriter.h"
#import "OFDataArray+RaknetMagic.h"

@implementation RaknetConnectionRequest
@synthesize protocolVersion, mtuSize;

- (instancetype)initWithData:(OFDataArray *)data {
    self = [super init];
    @try {
        if (![data checkMagic]) {
            [self release];
            return nil;
        }
        self.protocolVersion = [data readByte];
        self.mtuSize = [data count];
    } @catch (id e) {
        [self release];
        @throw e;
    }
    return self;
}

+ (uint8_t)packetId {
    return 0x05;
}

- (OFDataArray *)packetData {
    OFDataArray *packetData = [[OFDataArray alloc] init];
    [packetData appendMagic];
    [packetData appendByte:self.protocolVersion];
    for (int i = 0; i<self.mtuSize; i++) {
        [packetData appendByte:0x00];
    }
    return packetData;
}

@end
