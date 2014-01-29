//
//  RaknetConnectionResponse2.h
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 09.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import <ObjFW/ObjFW.h>
#import "RaknetPacket.h"

@interface RaknetConnectionResponse2 : RaknetPacket

@property (nonatomic) int64_t serverId;
@property (nonatomic) int16_t mtuSize;
@property (nonatomic) int16_t clientUDPPort;
@property (nonatomic) int8_t serverSecurity;

- (instancetype)initWithMtuSize:(int16_t)mtuSize andClientPort:(int16_t)port;

@end
