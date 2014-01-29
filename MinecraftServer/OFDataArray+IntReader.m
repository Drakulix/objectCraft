//
//  OFDataArray+IntReader.m
//  MinecraftServer
//
//  Created by Victor Brekenfeld on 28.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "OFDataArray+IntReader.h"

@implementation OFDataArray (IntReader)

- (int32_t)readInt {
    int32_t integer = OF_BSWAP32_IF_LE(*(int32_t *)[self firstItem]);
    [self removeItemsInRange:of_range(0, sizeof(int32_t))];
    return integer;
}

- (int24_t)readInt24 {
    int24_t val;
#ifdef OF_BIG_ENDIAN
        val.bytes[0] = 0x00;
        val.bytes[1] = [self readByte];
        val.bytes[2] = [self readByte];
        val.bytes[3] = [self readByte];
#else
        val.bytes[3] = 0x00;
        val.bytes[2] = [self readByte];
        val.bytes[1] = [self readByte];
        val.bytes[0] = [self readByte];
#endif
    return val;
}

- (uint24_t)readUInt24 {
    uint24_t val;
#ifdef OF_BIG_ENDIAN
        val.bytes[0] = 0x00;
        val.bytes[1] = [self readByte];
        val.bytes[2] = [self readByte];
        val.bytes[3] = [self readByte];
#else
        val.bytes[3] = 0x00;
        val.bytes[2] = [self readByte];
        val.bytes[1] = [self readByte];
        val.bytes[0] = [self readByte];
#endif
    return val;
}

- (uint24_t)readReverseUInt24 {
    uint24_t val;
#ifdef OF_BIG_ENDIAN
        val.bytes[3] = 0x00;
        val.bytes[2] = [self readByte];
        val.bytes[1] = [self readByte];
        val.bytes[0] = [self readByte];
#else
        val.bytes[0] = 0x00;
        val.bytes[1] = [self readByte];
        val.bytes[2] = [self readByte];
        val.bytes[3] = [self readByte];
#endif
    return val;
}

- (int16_t)readShort {
    int16_t shortInt = OF_BSWAP16_IF_LE(*(int16_t *)[self firstItem]);
    [self removeItemsInRange:of_range(0, sizeof(int16_t))];
    return shortInt;
}

- (int8_t)readByte {
    int8_t shortInt = *(int8_t *)[self firstItem];
    [self removeItemsInRange:of_range(0, sizeof(int8_t))];
    return shortInt;
}

- (BOOL)readBoolTcp {
    int8_t shortInt = *(int8_t *)[self firstItem];
    [self removeItemsInRange:of_range(0, sizeof(int8_t))];
    return (shortInt == 0x01);
}

- (BOOL)readBoolUdp {
    int8_t shortInt = *(int8_t *)[self firstItem];
    [self removeItemsInRange:of_range(0, sizeof(int8_t))];
    return (shortInt == 0x00);
}

- (int64_t)readLong {
    int64_t longInt = OF_BSWAP64_IF_LE(*(int64_t *)[self firstItem]);
    [self removeItemsInRange:of_range(0, sizeof(int64_t))];
    return longInt;
}

@end
