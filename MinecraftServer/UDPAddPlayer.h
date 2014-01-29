//
//  UDPAddPlayer.h
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 20.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "UDPPacket.h"
#import "Player.h"

@interface UDPAddPlayer : UDPPacket

@property uint64_t clientID;
@property NSString *username;
@property int32_t entityId;

@property float X;
@property float Y;
@property float Z;
@property float Yaw;
@property float Pitch;

@property int16_t unknown;
@property int16_t unknown2;

@property NSMutableData *metadata;

- (id)initWithPlayer:(Player *)player;

@end
