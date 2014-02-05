//
//  TCPPlayerPositionRead.m
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 07.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "TCPPlayerPositionClient.h"
#import "OFDataArray+IntReader.h"
#import "OFDataArray+FloatReader.h"

@implementation TCPPlayerPositionClient

- (instancetype)initWithData:(OFDataArray *)data {
    self = [super init];
    if (self) {
        _X = [data readDouble];
        _Stance = [data readDouble];
        _Y = [data readDouble];
        _Z = [data readDouble];
        _OnGround = [data readBoolTcp];
    }
    return self;
}

+ (uint64_t)packetId {
    return 0x04;
}

@end
