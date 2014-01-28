//
//  OFDataArray+IntReader.h
//  MinecraftServer
//
//  Created by Victor Brekenfeld on 28.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import <ObjFW/ObjFW.h>
#import "int24_t.h"
#import "longlongbyteorder.h"

@interface OFDataArray (IntReader)

- (int64_t)readLong;
- (int32_t)readInt;
- (int24_t)readInt24;
- (uint24_t)readUInt24;
- (uint24_t)readReverseUInt24;
- (int16_t)readShort;
- (int8_t)readByte;
- (BOOL)readBoolTcp;
- (BOOL)readBoolUdp;

@end
