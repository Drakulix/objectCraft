//
//  UDPLoginStatus.m
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 10.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "UDPLoginStatus.h"
#import "OFDataArray+IntReader.h"
#import "OFDataArray+IntWriter.h"

@implementation UDPLoginStatus

- (instancetype)initWithStatus:(int32_t)status {
    self = [super init];
    @try {
        self.status = status;
    } @catch (id e) {
        [self release];
        @throw e;
    }
    return self;
}

- (instancetype)initWithData:(OFDataArray *)data {
    self = [super init];
    @try {
        self.status = [data readInt];
    } @catch (id e) {
        [self release];
        @throw e;
    }
    return self;
}

+ (uint8_t)packetId {
    return 0x83;
}

- (OFDataArray *)packetData {
    OFDataArray *packetData = [OFDataArray dataArray];
    [packetData appendInt:self.status];
    return packetData;
}

@end
