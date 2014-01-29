//
//  UDPServerHandshake.h
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 09.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "UDPPacket.h"

@interface UDPServerHandshake : UDPPacket

@property int32_t cookie;
@property int8_t security;

@property uint16_t port;

@property NSData *dataArray;
@property int16_t timeStamp;

@property int64_t session;
@property int64_t session2;

- (instancetype)initWithPort:(uint16_t)port sessionId:(int64_t)session serverSessionId:(int64_t)session2;

@end
