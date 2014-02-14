//
//  TCPStatusPing.m
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 10.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "TCPStatusPing.h"
#import "OFDataArray+IntReader.h"

@implementation TCPStatusPing

- (instancetype)initWithData:(OFDataArray *)data {
    self = [super init];
    @try {
        self.time = [data readLong];
    } @catch (id e) {
        [self release];
        @throw e;
    }
    return self;
}

+ (int)state {
    return 1;
}

+ (uint64_t)packetId {
    return 0x01;
}

@end
