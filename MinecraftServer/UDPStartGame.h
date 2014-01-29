//
//  UDPStartGamePacket.h
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 10.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "UDPPacket.h"
@class Player;

@interface UDPStartGame : UDPPacket

@property (nonatomic) int32_t seed;
@property (nonatomic) int32_t generator;
@property (nonatomic) int32_t gamemode;
@property (nonatomic) int32_t entityId;
@property (nonatomic) float X;
@property (nonatomic) float Y;
@property (nonatomic) float Z;

- (instancetype)initWithPlayer:(Player *)player;

@end
