//
//  MovingEntity.h
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 06.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "Entity.h"

@interface MovingEntity : Entity

@property (atomic) bool OnGround;

@property (atomic) bool canFly;
@property (atomic) bool isFlying;

@property (atomic) float flyingSpeed;
@property (atomic) float walkingSpeed;

@end
