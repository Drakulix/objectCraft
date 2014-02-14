//
//  UDPMoveEntity.m
//  
//
//  Created by Victor Brekenfeld on 22.01.14.
//
//

#import "UDPMoveEntity.h"
#import "MovingEntity.h"
#import "OFDataArray+IntReader.h"
#import "OFDataArray+IntWriter.h"
#import "OFDataArray+FloatReader.h"
#import "OFDataArray+FloatWriter.h"

@implementation UDPMoveEntity

- (id)initWithEntity:(MovingEntity *)entity {
    self = [super init];
    @try {
        self.entityId = [entity entityId];
        self.X = (float)entity.X;
        self.Y = (float)entity.Y;
        self.Z = (float)entity.Z;
        self.Yaw = entity.Yaw;
        self.Pitch = entity.Pitch;
    } @catch (id e) {
        [self release];
        @throw e;
    }
    return self;
}

- (id)initWithData:(OFDataArray *)data {
    self = [super init];
    @try {
        self.entityId = [data readInt];
        self.X = [data readFloat];
        self.Y = [data readFloat];
        self.Z = [data readFloat];
        self.Yaw = [data readFloat];
        self.Pitch = [data readFloat];
    } @catch (id e) {
        [self release];
        @throw e;
    }
    return self;
}

+ (uint8_t)packetId {
    return 0x90;
}

- (OFDataArray *)packetData {
    OFDataArray *packetData = [OFDataArray dataArray];
    [packetData appendInt:self.entityId];
    [packetData appendFloat:self.X];
    [packetData appendFloat:self.Y];
    [packetData appendFloat:self.Z];
    [packetData appendFloat:self.Yaw];
    [packetData appendFloat:self.Pitch];
    return packetData;
}

@end
