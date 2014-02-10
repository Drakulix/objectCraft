//
//  LivingEntity.h
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 06.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "MovingEntity.h"

@interface LivingEntity : MovingEntity

@property (atomic) bool canBeDamaged;
@property (atomic) int16_t health;

@end
