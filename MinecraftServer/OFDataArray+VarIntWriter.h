//
//  OFDataArray+VarIntWriter.h
//  MinecraftServer
//
//  Created by Victor Brekenfeld on 28.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import <ObjFW/ObjFW.h>

@interface OFDataArray (VarIntWriter)

- (void)prependVarInt:(uint64_t)integer;
- (void)appendVarInt:(uint64_t)integer;
- (void)appendSignedVarInt:(int64_t)integer;

@end
