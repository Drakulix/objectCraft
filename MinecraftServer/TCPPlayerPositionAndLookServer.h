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

@property (readonly) double X;
@property (readonly) double Y;
@property (readonly) double Z;

@property (readonly) float Yaw;
@property (readonly) float Pitch;

@property (readonly) BOOL OnGround;

- (instancetype)initWithPlayer:(Player *)player;

@end
