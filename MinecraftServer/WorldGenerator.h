//
//  WorldGenerator.h
//  MinecraftServer
//
//  Created by Victor Brekenfeld on 27.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import <ObjFW/ObjFW.h>
@class RandomGenerator;

@interface WorldGenerator : OFObject {
    RandomGenerator *random;
}

- (instancetype)initWithSeed:(uint64_t)seed;
- (uint64_t)generatorState;

@end
