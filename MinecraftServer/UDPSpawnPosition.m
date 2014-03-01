//
//  UDPSpawnPosition.m
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 10.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "UDPSpawnPosition.h"
#import "OFDataArray+IntReader.h"
#import "OFDataArray+IntWriter.h"
#import "Player.h"

@implementation UDPSpawnPosition

- (instancetype)initWithPlayer:(Player *)player {
    self = [super init];
    @try {
        self.X = [player blockPosX];
        self.Z = [player blockPosZ];
        self.Y = (int8_t)[player blockPosY];
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
        self.Y = [data readByte];
    } @catch (id e) {
        [self release];
        @throw e;
    }
    return self;
}

+ (uint8_t)packetId {
    return 0xaa;
}

- (OFDataArray *)packetData {
    OFDataArray *packetData = [OFDataArray dataArray];
    
    [packetData appendInt:self.X];
    [packetData appendInt:self.Z];
    [packetData appendByte:self.Y];
    
    return packetData;
}


@end
