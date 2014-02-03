//
//  OFDataArray+VarIntWriter.m
//  MinecraftServer
//
//  Created by Victor Brekenfeld on 28.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "OFDataArray+VarIntWriter.h"
#import <stdint.h>

// Encode an unsigned 64-bit varint.  Returns number of encoded bytes.
// 'buffer' must have room for up to 10 bytes.
int encode_unsigned_varint(uint8_t *const buffer, uint64_t value)
{
    int encoded = 0;
    
    do
    {
        uint8_t next_byte = value & 0x7F;
        value >>= 7;
        
        if (value)
            next_byte |= 0x80;
        
        buffer[encoded++] = next_byte;
        
    } while (value);
    
    
    return encoded;
}

// Encode a signed 64-bit varint.  Works by first zig-zag transforming
// signed value into an unsigned value, and then reusing the unsigned
// encoder.  'buffer' must have room for up to 10 bytes.
int encode_signed_varint(uint8_t *const buffer, int64_t value)
{
    uint64_t uvalue;
    
    uvalue = uint64_t( value < 0 ? ~(value << 1) : (value << 1) );
    
    return encode_unsigned_varint( buffer, uvalue );
}

@implementation OFDataArray (VarIntWriter)

- (void)prependVarInt:(uint64_t)integer {
    uint8_t *const buffer = (uint8_t *const)malloc(10);
    int length = encode_unsigned_varint(buffer, integer);
    [self insertItems:buffer atIndex:0 count:length];
    free(buffer);
}

- (void)appendVarInt:(uint64_t)integer {
    uint8_t *const buffer = (uint8_t *const)malloc(10);
    int length = encode_unsigned_varint(buffer, integer);
    [self addItems:buffer count:length];
    free(buffer);
}

- (void)appendSignedVarInt:(int64_t)integer {
    uint8_t *const buffer = (uint8_t *const)malloc(10);
    int length = encode_signed_varint(buffer, integer);
    [self addItems:buffer count:length];
    free(buffer);
}

@end
