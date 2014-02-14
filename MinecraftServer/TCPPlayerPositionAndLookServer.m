//
//  TCPPlayerPositionAndLook.m
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 07.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "TCPPlayerPositionAndLookServer.h"
#import "OFDataArray+IntWriter.h"
#import "OFDataArray+FloatWriter.h"

@implementation TCPPlayerPositionAndLookServer

- (instancetype)initWithPlayer:(Player *)player {
    self = [super init];
    @try {
        self.X = player.X;
        self.Y = player.Y;
        self.Z = player.Z;
        self.Yaw = player.Yaw;
        self.Pitch = player.Pitch;
        self.OnGround = player.OnGround;
    } @catch (id e) {
        [self release];
        @throw e;
    }
    return self;
}

+ (uint64_t)packetId {
    return 0x08;
}

- (OFDataArray *)packetData {
    OFDataArray *packetData = [OFDataArray dataArray];
    [packetData appendDouble:self.X];
    [packetData appendDouble:self.Y];
    [packetData appendDouble:self.Z];
    [packetData appendFloat:self.Yaw];
    [packetData appendFloat:self.Pitch];
    [packetData appendBoolTcp:self.OnGround];
    return packetData;
}

@end