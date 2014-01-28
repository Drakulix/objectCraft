//
//  OFRandom.h
//  MinecraftServer
//
//  Created by Victor Brekenfeld on 23.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import <ObjFW/ObjFW.h>

@interface RandomGenerator : OFObject {
    @private
    uint64_t next;
}

+ (RandomGenerator *)globalGenerator;
- (void)setSeed:(uint64_t)seed;
- (uint64_t)currentSeed;

- (int8_t)nextRandomInt8;
- (uint8_t)nextRandomUnsignedInt8;


- (int16_t)nextRandomInt16;
- (uint16_t)nextRandomUnsignedInt16;


- (int32_t)nextRandomInt32;
- (uint32_t)nextRandomUnsignedInt32;


- (int64_t)nextRandomInt64;
- (uint64_t)nextRandomUnsignedInt64;

@end
