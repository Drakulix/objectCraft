//
//  TCPPlayerPositionAndLook.h
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 07.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "TCPServerPacket.h"
#import "Player.h"

@interface TCPPlayerPositionAndLookServer : TCPServerPacket

@property (nonatomic) double X;
@property (nonatomic) double Y;
@property (nonatomic) double Z;

@property (nonatomic) float Yaw;
@property (nonatomic) float Pitch;

@property (nonatomic) BOOL OnGround;

- (instancetype)initWithPlayer:(Player *)player;

@end
