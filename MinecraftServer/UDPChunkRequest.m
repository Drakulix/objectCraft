//
//  UDPChunkRequest.m
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 22.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "UDPChunkRequest.h"

@implementation UDPChunkRequest

- (instancetype)initForX:(int32_t)x Z:(int32_t)z {
    self = [super init];
    if (self) {
        self.X = x;
        self.Z = z;
    }
    return self;
}

- (instancetype)initWithData:(NSData *)data {
    self = [super init];
    if (self) {
        NSMutableData *packetData = [data mutableCopy];
        self.X = [packetData readInt];
        self.Z = [packetData readInt];
    }
    return self;
}

+ (uint8_t)packetId {
    return 0x9e;
}

- (NSData *)packetData {
    NSMutableData *packetData = [[NSMutableData alloc] init];
    
    [packetData appendInt:self.X];
    [packetData appendInt:self.Z];
    
    return packetData;
}

@end
