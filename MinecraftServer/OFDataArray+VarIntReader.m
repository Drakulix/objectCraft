//
//  OFDataArray+VarIntReader.m
//  MinecraftServer
//
//  Created by Victor Brekenfeld on 28.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "OFDataArray+VarIntReader.h"

uint64_t decode_unsigned_varint( const uint8_t *const data, int *decoded_bytes )
{
    int i = 0;
    uint64_t decoded_value = 0;
    int shift_amount = 0;
    
    do {
        decoded_value |= (uint64_t)(data[i] & 0x7F) << shift_amount;
        shift_amount += 7;
    } while ( (data[i++] & 0x80) != 0 );
    
    if (decoded_bytes != NULL)
        *decoded_bytes = i;
    return decoded_value;
}

int64_t decode_signed_varint( const uint8_t *const data, int *decoded_bytes )
{
    uint64_t unsigned_value = decode_unsigned_varint(data, decoded_bytes);
    return (int64_t)( unsigned_value & 1 ? ~(unsigned_value >> 1)
                     :  (unsigned_value >> 1) );
}

@implementation OFDataArray (VarIntReader)

- (uint64_t)readVarInt {
    int varLength;
    uint64_t var = decode_unsigned_varint([self firstItem], &varLength);
    [self removeItemsInRange:of_range(0, varLength)];
    return var;
}

- (int64_t)readSignedVarInt {
    int varLength;
    int64_t var = decode_signed_varint([self firstItem], &varLength);
    [self removeItemsInRange:of_range(0, varLength)];
    return var;
}

@end
