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

@interface OFTCPSocket (VarIntReader)

- (void)asyncReadVarIntForTarget:(id)target selector:(SEL)selector;
- (void)asyncReadSignedVarIntForTarget:(id)target selector:(SEL)selector;

@end

@interface AsyncVarIntReader : OFObject {
    int8_t buffer;
    BOOL sign;
    id target;
    SEL selector;
    OFDataArray *varData;
    OFTCPSocket *socket;
}

- (instancetype)initWithSocket:(OFTCPSocket *)tcpSocket signed:(BOOL)sign forTarget:(id)target andSelector:(SEL)selector;

@end