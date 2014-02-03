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

@implementation OFTCPSocket (VarIntReader)

- (void)asyncReadVarIntForTarget:(id)target selector:(SEL)selector {
    [[AsyncVarIntReader alloc] initWithSocket:self signed:NO forTarget:target andSelector:selector];
}

- (void)asyncReadSignedVarIntForTarget:(id)target selector:(SEL)selector {
    [[AsyncVarIntReader alloc] initWithSocket:self signed:YES forTarget:target andSelector:selector];
}

@end

@implementation AsyncVarIntReader

- (instancetype)initWithSocket:(OFTCPSocket *)tcpSocket signed:(BOOL)_sign forTarget:(id)_target andSelector:(SEL)_selector {
    self = [super init];
    if (self) {
        sign = _sign;
        target = _target;
        selector = _selector;
        varData = [[OFDataArray alloc] initWithItemSize:sizeof(int8_t)];
        socket = tcpSocket;
        [tcpSocket asyncReadIntoBuffer:&buffer exactLength:sizeof(int8_t) target:self selector:@selector(readFrom:buffer:ofSize:error:)];
    }
    return self;
}

- (BOOL)readFrom:(OFStream *)stream buffer:(void *)buffer ofSize:(size_t)size error:(OFException *)exception {
    
    if (exception) {
        bool (*func)(id, SEL, OFStream *, uint64_t, OFException*) = (bool(*)(id, SEL, OFStream*, uint64_t, OFException*)) [target methodForSelector:selector];
        func(target, selector, socket, 0, exception);
    }
    
    [varData addItem:buffer];
    if (((*(uint8_t *)buffer) & 0x80) != 0) {
        return YES;
    } else {
        if (sign) {
            int64_t varInt = decode_signed_varint([varData firstItem], NULL);
            bool (*func)(id, SEL, OFStream *, int64_t, OFException*) = (bool(*)(id, SEL, OFStream*, int64_t, OFException*)) [target methodForSelector:selector];
            func(target, selector, socket, varInt, nil);
        }
        if (!sign) {
            uint64_t varInt = decode_unsigned_varint([varData firstItem], NULL));
            bool (*func)(id, SEL, OFStream *, uint64_t, OFException*) = (bool(*)(id, SEL, OFStream*, uint64_t, OFException*)) [target methodForSelector:selector];
            func(target, selector, socket, varInt, nil);
        }
        [self autorelease];
        return NO;
    }
}

@end