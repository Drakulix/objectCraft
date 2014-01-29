//
//  WorldGenerator.m
//  MinecraftServer
//
//  Created by Victor Brekenfeld on 27.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "WorldGenerator.h"
#import "RandomGenerator.h"

@implementation WorldGenerator

- (instancetype)initWithSeed:(uint64_t)seed {
    self = [super init];
    if (self) {
        random = [[RandomGenerator alloc] init];
        random.seed = seed;
    }
    return self;
}

- (uint64_t)generatorState {
    return random.seed;
}

@end
