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
