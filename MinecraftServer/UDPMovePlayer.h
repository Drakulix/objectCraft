//
//  UDPMovePlayer.h
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 22.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "UDPMoveEntity.h"
#import "Player.h"

@interface UDPMovePlayer : UDPMoveEntity

@property float unknown;

- (id)initWithPlayer:(Player *)player;

@end
