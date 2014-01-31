//
//  Entity.h
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 06.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import <ObjFW/ObjFW.h>

@interface Entity : OFObject

@property (atomic) int32_t entityId;
@property (atomic) int8_t dimension;
@property (atomic) int8_t tcpDimension;

@property (atomic) double X;
@property (atomic) double Y;
@property (atomic) double Z;

@property (atomic) float Yaw;
@property (atomic) float Pitch;

- (int32_t)blockPosX;
- (int32_t)blockPosY;
- (int32_t)blockPosZ;

- (void)despawn;

@end
