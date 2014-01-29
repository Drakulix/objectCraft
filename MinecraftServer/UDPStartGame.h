//
//  UDPStartGamePacket.h
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 10.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "UDPPacket.h"
#import "Player.h"

@interface UDPStartGame : UDPPacket

@property int32_t seed;
@property int32_t generator;
@property int32_t gamemode;
@property int32_t entityId;
@property float X;
@property float Y;
@property float Z;

- (instancetype)initWithPlayer:(Player *)player;

@end
