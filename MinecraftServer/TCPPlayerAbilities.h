//
//  TCPPlayerAbilities.h
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 06.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import <ObjFW/ObjFW.h>
#import "TCPServerPacket.h"
#import "Player.h"

@interface TCPPlayerAbilities : TCPServerPacket

@property BOOL canBeDamaged;
@property BOOL canFly;
@property BOOL isFlying;
@property BOOL isCreativeMode;
@property float flyingSpeed;
@property float walkingSpeed;

- (instancetype)initWithPlayer:(Player *)player;

@end