//
//  NSMutableData+IntWriter.h
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 06.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import <ObjFW/ObjFW.h>
#import "int24_t.h"

typedef union {
    struct {
        unsigned int first:4;
        unsigned int second:4;
    } nibbles;
    uint8_t byte_value;
} Nibbler ;

typedef union {
    struct {
        unsigned int bit1:2;
        unsigned int bit2:2;
        unsigned int bit3:2;
        unsigned int bit4:2;
    } bits;
    uint8_t byte_value;
} BitArray ;

@interface OFDataArray (IntWriter)

- (void)appendLong:(int64_t)integer;
- (void)appendInt24:(int24_t)integer;
- (void)appendReverseUInt24:(uint24_t)integer;
- (void)appendUInt24:(uint24_t)integer;
- (void)appendInt:(int32_t)integer;
- (void)appendShort:(int16_t)shortInt;
- (void)appendUnsignedByte:(uint8_t)byte;
- (void)appendByte:(int8_t)byte;
- (void)appendNibbler:(Nibbler)nibb;
- (void)appendBitArray:(BitArray)bits;
- (void)appendBoolTcp:(BOOL)boolean;
- (void)appendBoolUdp:(BOOL)boolean;

@end
