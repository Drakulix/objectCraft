//
//  WorldGenerator.h
//  MinecraftServer
//
//  Created by Victor Brekenfeld on 27.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import <ObjFW/ObjFW.h>
@class RandomGenerator;
@class Chunk;

@interface WorldGenerator : OFObject {
    RandomGenerator *random;
}

@property (nonatomic, readonly) int8_t tcpDimension;

- (instancetype)initWithSeed:(uint64_t)seed;
- (uint64_t)generatorState;

- (Chunk *)generatedChunkAtX:(int32_t)x AtY:(int32_t)y AtZ:(int32_t)z;

@end
