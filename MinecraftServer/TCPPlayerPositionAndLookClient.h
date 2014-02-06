//
//  TCPPlayerPositionRead.h
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 07.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "TCPClientPacket.h"

@interface TCPPlayerPositionAndLookClient : TCPClientPacket

@property (nonatomic) double X;
@property (nonatomic) double FeetY;
@property (nonatomic) double HeadY;
@property (nonatomic) double Z;

@property (nonatomic) float Yaw;
@property (nonatomic) float Pitch;

@property (nonatomic) BOOL OnGround;

@end
