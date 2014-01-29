//
//  UDPMoveEntity.h
//  
//
//  Created by Victor Brekenfeld on 22.01.14.
//
//

#import "UDPPacket.h"
#import "MovingEntity.h"

@interface UDPMoveEntity : UDPPacket

@property int32_t entityId;

@property float X;
@property float Y;
@property float Z;
@property float Yaw;
@property float Pitch;

- (id)initWithEntity:(MovingEntity *)entity;

@end
