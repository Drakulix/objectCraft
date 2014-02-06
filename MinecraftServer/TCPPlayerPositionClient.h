//
//  TCPPlayerPositionRead.h
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 07.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "TCPClientPacket.h"

@interface TCPPlayerPositionClient : TCPClientPacket

@property (nonatomic) double X;
@property (nonatomic) double feetY;
@property (nonatomic) double headY;
@property (nonatomic) double Z;

@property (nonatomic) BOOL OnGround;

@end
