//
//  RaknetMinecraftPacket.h
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 09.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import <ObjFW/ObjFW.h>
#import "RaknetPacket.h"
#import "int24_t.h"

@class RaknetHandler;

@interface RaknetMinecraftPacket : OFObject {
    uint24_t count;
    uint24_t orderId;
}

@property uint16_t dataLength;

@property BOOL isReliable;
@property uint32_t count;

@property BOOL isOrdered;
@property uint32_t orderId;
@property uint8_t orderChannel;

@property BOOL isSplit;
@property int32_t splitCount;
@property int16_t splitId;
@property int32_t splitIndex;

@property OFDataArray *packet;

+ (RaknetMinecraftPacket *)readPacketFromData:(OFDataArray *)data;

- (instancetype)initWithData:(OFDataArray *)data;
- (instancetype)initReliableWithData:(OFDataArray *)data count:(uint24_t)_count;
- (instancetype)initSplitPacketWithData:(OFDataArray *)data count:(uint24_t)_count splitCount:(int32_t)splitCount splitId:(int16_t)splitId splitIndex:(int32_t)splitIndex;

- (OFDataArray *)packetData;

- (uint32_t)orderId;
- (void)setOrderId:(uint32_t)orderId;
- (void)setOrderId24:(uint24_t)orderId;

- (uint32_t)count;
- (void)setCount:(uint32_t)count;
- (void)setCount24:(uint24_t)count;

@end
