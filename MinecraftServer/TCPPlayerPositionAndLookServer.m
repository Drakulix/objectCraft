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
    if (self) {
        _X = player.X;
        _Y = player.Y;
        _Z = player.Z;
        _Yaw = player.Yaw;
        _Pitch = player.Pitch;
        _OnGround = player.OnGround;
    }
    return self;
}

+ (uint64_t)packetId {
    return 0x08;
}

- (OFDataArray *)packetData {
    OFDataArray *packetData = [[OFDataArray alloc] init];
    
    [packetData appendDouble:self.X];
    [packetData appendDouble:self.Y];
    [packetData appendDouble:self.Z];
    [packetData appendFloat:self.Yaw];
    [packetData appendFloat:self.Pitch];
    [packetData appendBoolTcp:self.OnGround];
    
    return packetData;
}

@end