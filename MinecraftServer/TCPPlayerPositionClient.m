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
@synthesize X, feetY, headY, Z, OnGround;

- (instancetype)initWithData:(OFDataArray *)data {
    self = [super init];
    @try {
        self.X = [data readDouble];
        self.feetY = [data readDouble];
        self.headY = [data readDouble];
        self.Z = [data readDouble];
        self.OnGround = [data readBoolTcp];
    } @catch (id e) {
        [self release];
        @throw e;
    }
    return self;
}

+ (uint64_t)packetId {
    return 0x04;
}

@end
