//
//  UDPSpawnPosition.h
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 10.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "UDPPacket.h"
@class Player;

@interface UDPSpawnPosition : UDPPacket

@property (nonatomic) int32_t X;
@property (nonatomic) uint8_t Y;
@property (nonatomic) int32_t Z;

- (instancetype)initWithPlayer:(Player *)player;

@end
