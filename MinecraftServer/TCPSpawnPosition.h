//
//  TCPSpawnPosition.h
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 06.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import <ObjFW/ObjFW.h>
#import "TCPServerPacket.h"

@interface TCPSpawnPosition : TCPServerPacket

@property (nonatomic) int32_t X;
@property (nonatomic) int32_t Y;
@property (nonatomic) int32_t Z;

- (instancetype)initWithX:(int32_t)x withY:(int32_t)y withZ:(int32_t)z;

@end
