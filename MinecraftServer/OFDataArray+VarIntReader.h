//
//  OFDataArray+VarIntReader.h
//  MinecraftServer
//
//  Created by Victor Brekenfeld on 28.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import <ObjFW/ObjFW.h>

@interface OFDataArray (VarIntReader)

- (uint64_t)readVarInt;
- (int64_t)readSignedVarInt;

@end

typedef bool (^VarIntBlock)(OFStream*, uint64_t, OFException*);

@interface OFStream (VarIntReader)

- (void)asyncReadVarIntForTarget:(id)target selector:(SEL)selector;
- (void)asyncReadVarIntWithBlock:(VarIntBlock)handler;

- (void)asyncReadSignedVarIntForTarget:(id)target selector:(SEL)selector;
- (void)asyncReadSignedVarIntWithBlock:(VarIntBlock)handler;

- (int64_t)readSignedVarInt;
- (uint64_t)readUnsignedVarInt;
- (int64_t)readSignedVarIntInLength:(int *)len;
- (uint64_t)readUnsignedVarIntInLength:(int *)len;

@end

@interface AsyncVarIntReader : OFObject {
    bool sign;
    id target;
    SEL selector;
    OFDataArray *varData;
    OFStream *stream;
    VarIntBlock block;
    void *buffer;
}

- (instancetype)initWithStream:(OFStream *)stream signed:(bool)sign forTarget:(id)target andSelector:(SEL)selector;
- (instancetype)initWithStream:(OFStream *)stream signed:(bool)sign withBlock:(VarIntBlock)handler;

@end