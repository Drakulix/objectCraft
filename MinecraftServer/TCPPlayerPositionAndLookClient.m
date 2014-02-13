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
@synthesize X, FeetY, HeadY, Z, Yaw, Pitch, OnGround;

- (instancetype)initWithData:(OFDataArray *)data {
    self = [super init];
    @try {
        self.X = [data readDouble];
        self.FeetY = [data readDouble];
        self.HeadY = [data readDouble];
        self.Z = [data readDouble];
        self.Yaw = [data readFloat];
        self.Pitch = [data readFloat];
        self.OnGround = [data readBoolTcp];
    } @catch (id e) {
        [self release];
        @throw e;
    }
    return self;
}

+ (uint64_t)packetId {
    return 0x06;
}

@end
