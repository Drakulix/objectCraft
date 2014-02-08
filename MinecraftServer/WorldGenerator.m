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
    @try {
        random = [[RandomGenerator alloc] init];
        random.seed = seed;
        self.tcpDimension = 0;
    } @catch (id e) {
        [self release];
        @throw e;
    }
    return self;
}

- (void)dealloc {
    [random release];
    [super dealloc];
}

- (uint64_t)generatorState {
    return random.seed;
}

- (Chunk *)generatedChunkAtX:(int32_t)x AtY:(int32_t)y AtZ:(int32_t)z {
    @throw [[OFNotImplementedException alloc] init];
}

@end
