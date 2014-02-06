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

@property (nonatomic) BOOL canBeDamaged;
@property (nonatomic) BOOL canFly;
@property (nonatomic) BOOL isFlying;
@property (nonatomic) BOOL isCreativeMode;
@property (nonatomic) float flyingSpeed;
@property (nonatomic) float walkingSpeed;

- (instancetype)initWithPlayer:(Player *)player;

@end