//
//  UDPSpawnPosition.m
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 10.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "UDPSpawnPosition.h"

@implementation UDPSpawnPosition

- (instancetype)initWithPlayer:(Player *)player {
    self = [super init];
    if (self) {
        self.X = [player blockPosX];
        self.Z = [player blockPosZ];
        self.Y = (int8_t)[player blockPosY]-64;
    }
    return self;
}

- (instancetype)initWithData:(NSData *)data {
    self = [super init];
    if (self) {
        NSMutableData *packetData = [data mutableCopy];
        self.X = [packetData readInt];
        self.Z = [packetData readInt];
        self.Y = [packetData readByte];
    }
    return self;
}

+ (uint8_t)packetId {
    return 0xab;
}

- (NSData *)packetData {
    NSMutableData *packetData = [[NSMutableData alloc] init];
    
    [packetData appendInt:self.X];
    [packetData appendInt:self.Z];
    [packetData appendByte:self.Y];
    
    return packetData;
}


@end
