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

- (instancetype)initForX:(int32_t)x Z:(int32_t)z {
    self = [super init];
    if (self) {
        self.X = x;
        self.Z = z;
    }
    return self;
}

- (instancetype)initWithData:(OFDataArray *)data {
    self = [super init];
    if (self) {
        self.X = [data readInt];
        self.Z = [data readInt];
    }
    return self;
}

+ (uint8_t)packetId {
    return 0x9e;
}

- (OFDataArray *)packetData {
    OFDataArray *packetData = [[OFDataArray alloc] init];
    
    [packetData appendInt:self.X];
    [packetData appendInt:self.Z];
    
    return packetData;
}

@end
