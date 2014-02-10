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
    uint64_t var = decode_unsigned_varint([self items], &varLength);
    [self removeItemsInRange:of_range(0, varLength)];
    return var;
}

- (int64_t)readSignedVarInt {
    int varLength;
    int64_t var = decode_signed_varint([self items], &varLength);
    [self removeItemsInRange:of_range(0, varLength)];
    return var;
}

@end

@implementation OFStream (VarIntReader)

- (void)asyncReadVarIntForTarget:(id)target selector:(SEL)selector {
    [[AsyncVarIntReader alloc] initWithStream:self signed:false forTarget:target andSelector:selector];
}

- (void)asyncReadSignedVarIntForTarget:(id)target selector:(SEL)selector {
    [[AsyncVarIntReader alloc] initWithStream:self signed:true forTarget:target andSelector:selector];
}


- (void)asyncReadVarIntWithBlock:(VarIntBlock)handler {
    [[AsyncVarIntReader alloc] initWithStream:self signed:false withBlock:handler];
}

- (void)asyncReadSignedVarIntWithBlock:(VarIntBlock)handler {
    [[AsyncVarIntReader alloc] initWithStream:self signed:true withBlock:handler];
}

@end

@implementation AsyncVarIntReader

- (instancetype)initWithStream:(OFStream *)_stream signed:(bool)_sign withBlock:(VarIntBlock)handler {
    self = [super init];
    @try {
        sign = _sign;
        varData = [[OFDataArray alloc] initWithItemSize:sizeof(int8_t)];
        stream = [_stream retain];
        block = [handler copy];
        buffer = malloc(sizeof(int8_t));
        [stream asyncReadIntoBuffer:buffer exactLength:sizeof(int8_t) block:^bool(OFStream *__stream, void *_buffer, size_t length, OFException *exception) {
            
            if (exception) {
                if (block(__stream, 0, exception)) {
                    [varData removeAllItems];
                    return true;
                } else {
                    [self autorelease];
                    return NO;
                }
            }
            
            [varData addItem:_buffer];
            if (((*(uint8_t *)_buffer) & 0x80) != 0) {
                return true;
            } else {
                bool result;
                if (sign) {
                    int64_t varInt = decode_signed_varint([varData items], NULL);
                    result = block(__stream, varInt, nil);
                }
                if (!sign) {
                    uint64_t varInt = decode_unsigned_varint([varData items], NULL);
                    result = block(__stream, varInt, nil);
                }
                if (result) {
                    [varData removeAllItems];
                } else {
                    [self autorelease];
                }
                return result;
            }
        }];
    } @catch (id e) {
        [self release];
        @throw e;
    }
    return self;
}

- (instancetype)initWithStream:(OFStream *)_stream signed:(bool)_sign forTarget:(id)_target andSelector:(SEL)_selector {
    self = [super init];
    @try {
        sign = _sign;
        target = [_target retain];
        selector = _selector;
        varData = [[OFDataArray alloc] initWithItemSize:sizeof(int8_t)];
        stream = [_stream retain];
        buffer = malloc(sizeof(int8_t));
        [stream asyncReadIntoBuffer:buffer exactLength:sizeof(int8_t) target:self selector:@selector(readFrom:buffer:ofSize:error:)];
    } @catch (id e) {
        [self release];
        @throw e;
    }
    return self;
}

- (bool)readFrom:(OFStream *)_stream buffer:(void *)_buffer ofSize:(size_t)size error:(OFException *)exception {
    
    if (exception) {
        bool (*func)(id, SEL, OFStream *, uint64_t, OFException*) = (bool(*)(id, SEL, OFStream*, uint64_t, OFException*)) [target methodForSelector:selector];
        if (func(target, selector, _stream, 0, exception)) {
            [varData removeAllItems];
            return true;
        } else {
            [self autorelease];
            return NO;
        }
    }
    
    [varData addItem:_buffer];
    if (((*(uint8_t *)_buffer) & 0x80) != 0) {
        return true;
    } else {
        bool result;
        if (sign) {
            int64_t varInt = decode_signed_varint([varData items], NULL);
            bool (*func)(id, SEL, OFStream *, int64_t, OFException*) = (bool(*)(id, SEL, OFStream*, int64_t, OFException*)) [target methodForSelector:selector];
            result = func(target, selector, _stream, varInt, nil);
        }
        if (!sign) {
            uint64_t varInt = decode_unsigned_varint([varData items], NULL);
            bool (*func)(id, SEL, OFStream *, uint64_t, OFException*) = (bool(*)(id, SEL, OFStream*, uint64_t, OFException*)) [target methodForSelector:selector];
            result = func(target, selector, _stream, varInt, nil);
        }
        
        if (result) {
            [varData removeAllItems];
        } else {
            [self autorelease];
        }
        return result;
    }
}

- (void)dealloc {
    if (target)
        [target release];
    if (block)
        [block release];
    free(buffer);
    [stream release];
    [super dealloc];
}

@end