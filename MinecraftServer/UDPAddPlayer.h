//
//  UDPAddPlayer.h
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 20.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "UDPPacket.h"
@class Player

@interface UDPAddPlayer : UDPPacket

@property (nonatomic) uint64_t clientID;
@property (nonatomic, retain) OFString *username;
@property (nonatomic) int32_t entityId;

@property (nonatomic) float X;
@property (nonatomic) float Y;
@property (nonatomic) float Z;
@property (nonatomic) float Yaw;
@property (nonatomic) float Pitch;

@property (nonatomic) int16_t unknown;
@property (nonatomic) int16_t unknown2;

@property OFDataArray *metadata;

- (id)initWithPlayer:(Player *)player;

@end
