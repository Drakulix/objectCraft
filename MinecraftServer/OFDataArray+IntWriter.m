//
//  NSMutableData+IntWriter.m
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 06.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "OFDataArray+IntWriter.h"

@implementation OFDataArray (IntWriter)

- (void)appendLong:(int64_t)intVal {
    int64_t nInt = OF_BSWAP64_IF_LE(intVal);
    [self addItems:&nInt count:sizeof(int64_t)];
}

- (void)appendInt:(int32_t)integer {
    int32_t nInt = OF_BSWAP32_IF_LE(integer);
    [self addItems:&nInt count:sizeof(int32_t)];
}

- (void)appendInt24:(int24_t)integer {
#ifdef OF_BIG_ENDIAN
        [self appendByte:integer.bytes[1]];
        [self appendByte:integer.bytes[2]];
        [self appendByte:integer.bytes[3]];
#else
        [self appendByte:integer.bytes[2]];
        [self appendByte:integer.bytes[1]];
        [self appendByte:integer.bytes[0]];
#endif
}

- (void)appendUInt24:(uint24_t)integer {
#ifdef OF_BIG_ENDIAN
        [self appendByte:integer.bytes[1]];
        [self appendByte:integer.bytes[2]];
        [self appendByte:integer.bytes[3]];
#else
        [self appendByte:integer.bytes[2]];
        [self appendByte:integer.bytes[1]];
        [self appendByte:integer.bytes[0]];
#endif
}

- (void)appendReverseUInt24:(uint24_t)integer {
#ifdef OF_BIG_ENDIAN
        [self appendByte:integer.bytes[3]];
        [self appendByte:integer.bytes[2]];
        [self appendByte:integer.bytes[1]];
#else
        [self appendByte:integer.bytes[0]];
        [self appendByte:integer.bytes[1]];
        [self appendByte:integer.bytes[2]];
#endif
}

- (void)appendShort:(int16_t)shortInt {
    int16_t nInt = OF_BSWAP16_IF_LE(shortInt);
    [self addItems:&nInt count:sizeof(int16_t)];
}

- (void)appendUnsignedByte:(uint8_t)byte {
    [self addItems:&byte count:sizeof(uint8_t)];
}

- (void)appendByte:(int8_t)byte {
    [self addItems:&byte count:sizeof(int8_t)];
}

- (void)appendBoolTcp:(BOOL)boolean {
    int8_t value;
    if (boolean) {
        value = 0x01;
    } else {
        value = 0x00;
    }
    [self appendByte:value];
}

- (void)appendBoolUdp:(BOOL)boolean {
    int8_t value;
    if (!boolean) {
        value = 0x01;
    } else {
        value = 0x00;
    }
    [self appendByte:value];
}

- (void)appendNibbler:(Nibbler)nibb {
    [self appendUnsignedByte:nibb.byte_value];
}

- (void)appendBitArray:(BitArray)bits {
    [self appendUnsignedByte:bits.byte_value];
}

@end
