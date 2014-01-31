//
//  NetherGenerator.m
//  MinecraftServer
//
//  Created by Victor Brekenfeld on 27.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "NetherGenerator.h"

@implementation NetherGenerator
@synthesize tcpDimension;

- (instancetype)initWithSeed:(uint64_t)seed {
    self = [super initWithSeed:seed];
    if (self) {
        tcpDimension = -1;
    }
    return self;
}

@end
