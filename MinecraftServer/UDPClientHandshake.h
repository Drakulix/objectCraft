//
//  UDPClientHandshake.h
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 10.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "UDPPacket.h"

@interface UDPClientHandshake : UDPPacket

@property int32_t cookie;
@property int8_t security;

@property uint16_t port;

@property NSData *dataArray0;
@property NSData *dataArray;

@property int16_t timeStamp;

@property int64_t session;
@property int64_t session2;

@end
