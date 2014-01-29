//
//  UDPClientHandshake.h
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 10.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "UDPPacket.h"

@interface UDPClientHandshake : UDPPacket

@property (nonatomic) int32_t cookie;
@property (nonatomic) int8_t security;

@property (nonatomic) uint16_t port;

@property (nonatomic, retain) OFDataArray *dataArray0;
@property (nonatomic, retain) OFDataArray *dataArray;

@property (nonatomic) int16_t timeStamp;

@property (nonatomic) int64_t session;
@property (nonatomic) int64_t session2;

@end
