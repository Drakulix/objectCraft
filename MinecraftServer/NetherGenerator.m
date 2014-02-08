//
//  NetherGenerator.m
//  MinecraftServer
//
//  Created by Victor Brekenfeld on 27.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "NetherGenerator.h"

@implementation NetherGenerator

- (instancetype)initWithSeed:(uint64_t)seed {
    self = [super initWithSeed:seed];
    @try {
        self.tcpDimension = -1;
    } @catch (id e) {
        [self release];
        @throw e;
    }
    return self;
}

@end
