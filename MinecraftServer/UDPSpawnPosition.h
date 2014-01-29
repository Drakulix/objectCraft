//
//  UDPSpawnPosition.h
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 10.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "UDPPacket.h"
#import "Player.h"

@interface UDPSpawnPosition : UDPPacket

@property int32_t X;
@property uint8_t Y;
@property int32_t Z;

- (instancetype)initWithPlayer:(Player *)player;

@end
