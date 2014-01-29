//
//  UDPMoveEntity.h
//  
//
//  Created by Victor Brekenfeld on 22.01.14.
//
//

#import "UDPPacket.h"
@class MovingEntity;

@interface UDPMoveEntity : UDPPacket

@property (nonatomic) int32_t entityId;

@property (nonatomic) float X;
@property (nonatomic) float Y;
@property (nonatomic) float Z;
@property (nonatomic) float Yaw;
@property (nonatomic) float Pitch;

- (id)initWithEntity:(MovingEntity *)entity;

@end
