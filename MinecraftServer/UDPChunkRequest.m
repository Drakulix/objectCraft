//
//  UDPChunkRequest.m
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 22.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "UDPChunkRequest.h"
#import "OFDataArray+IntReader.h"
#import "OFDataArray+IntWriter.h"

@implementation UDPChunkRequest
@synthesize X, Z;

- (instancetype)initForX:(int32_t)x Z:(int32_t)z {
    self = [super init];
    @try {
        self.X = x;
        self.Z = z;
    } @catch (id e) {
        [self release];
        @throw e;
    }
    return self;
}

- (instancetype)initWithData:(OFDataArray *)data {
    self = [super init];
    @try {
        self.X = [data readInt];
        self.Z = [data readInt];
    } @catch (id e) {
        [self release];
        @throw e;
    }
    return self;
}

+ (uint8_t)packetId {
    return 0x9e;
}

- (OFDataArray *)packetData {
    OFDataArray *packetData = [OFDataArray dataArray];
    
    [packetData appendInt:self.X];
    [packetData appendInt:self.Z];
    
    return packetData;
}

@end
