//
//  EndGenerator.m
//  MinecraftServer
//
//  Created by Victor Brekenfeld on 27.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "EndGenerator.h"

@implementation EndGenerator
@synthesize tcpDimension;

- (instancetype)initWithSeed:(uint64_t)seed {
    self = [super initWithSeed:seed];
    @try {
        tcpDimension = 1;
    } @catch (id e) {
        [self release];
        @throw e;
    }
    return self;
}

@end
