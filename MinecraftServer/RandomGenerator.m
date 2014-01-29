//
//  OFRandom.m
//  MinecraftServer
//
//  Created by Victor Brekenfeld on 23.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "RandomGenerator.h"
#import <sys/time.h>
const uint64_t customRandMax = 32767;

@implementation RandomGenerator
static RandomGenerator *randomGenerator;

- (instancetype)init {
    self = [super init];
    if (self) {
        struct timeval t1;
        gettimeofday(&t1, NULL);
        self.seed = t1.tv_usec * t1.tv_sec;
    }
    return self;
}

+ (RandomGenerator *)globalGenerator {
    if (!randomGenerator)
        randomGenerator = [[self alloc] init];
    return randomGenerator;
}

- (uint8_t)nextRandomUnsignedInt8 {
    self.seed = self.seed * 1103515245 + 12345;
    return (uint8_t)(self.seed/65536) % (customRandMax+1);
}

- (int8_t)nextRandomInt8 {
    uint8_t randomNum = [self nextRandomUnsignedInt8];
    return *(int8_t *)&randomNum; //cast to avoid integer conversion
}


- (int16_t)nextRandomInt16 {
    return (((int16_t)[self nextRandomInt8]) << 8) +
            (((int16_t)[self nextRandomInt8]));
}

- (uint16_t)nextRandomUnsignedInt16 {
    return (((uint16_t)[self nextRandomUnsignedInt8]) << 8) +
            (((uint16_t)[self nextRandomUnsignedInt8]));
}

- (int32_t)nextRandomInt32 {
    return (((int32_t)[self nextRandomInt8]) << 24) +
            (((int32_t)[self nextRandomInt8]) << 16) +
            (((int32_t)[self nextRandomInt8]) << 8) +
            (((int32_t)[self nextRandomInt8]));
}

- (uint32_t)nextRandomUnsignedInt32 {
     return (((uint32_t)[self nextRandomUnsignedInt8]) << 24) +
            (((uint32_t)[self nextRandomUnsignedInt8]) << 16) +
            (((uint32_t)[self nextRandomUnsignedInt8]) << 8) +
            (((uint32_t)[self nextRandomUnsignedInt8]));
}

- (int64_t)nextRandomInt64 {
    return (((int64_t)[self nextRandomInt8]) << 56) +
            (((int64_t)[self nextRandomInt8]) << 48) +
            (((int64_t)[self nextRandomInt8]) << 40) +
            (((int64_t)[self nextRandomInt8]) << 32) +
            (((int64_t)[self nextRandomInt8]) << 24) +
            (((int64_t)[self nextRandomInt8]) << 16) +
            (((int64_t)[self nextRandomInt8]) << 8) +
            (((int64_t)[self nextRandomInt8]));
}
- (uint64_t)nextRandomUnsignedInt64 {
    return (((uint64_t)[self nextRandomUnsignedInt8]) << 56) +
            (((uint64_t)[self nextRandomUnsignedInt8]) << 48) +
            (((uint64_t)[self nextRandomUnsignedInt8]) << 40) +
            (((uint64_t)[self nextRandomUnsignedInt8]) << 32) +
            (((uint64_t)[self nextRandomUnsignedInt8]) << 24) +
            (((uint64_t)[self nextRandomUnsignedInt8]) << 16) +
            (((uint64_t)[self nextRandomUnsignedInt8]) << 8) +
            (((uint64_t)[self nextRandomUnsignedInt8]));
}


@end
