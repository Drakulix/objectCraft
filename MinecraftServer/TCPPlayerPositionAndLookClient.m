//
//  TCPPlayerPositionRead.m
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 07.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "TCPPlayerPositionAndLookClient.h"
#import "OFDataArray+FloatReader.h"
#import "OFDataArray+IntReader.h"

@implementation TCPPlayerPositionAndLookClient

- (instancetype)initWithData:(OFDataArray *)data {
    self = [super init];
    if (self) {
        _X = [data readDouble];
        _FeetY = [data readDouble];
        _HeadY = [data readDouble];
        _Z = [data readDouble];
        _Yaw = [data readFloat];
        _Pitch = [data readFloat];
        _OnGround = [data readBoolTcp];
    }
    return self;
}

+ (uint64_t)packetId {
    return 0x06;
}

@end
