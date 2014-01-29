//
//  UDPMoveEntity.m
//  
//
//  Created by Victor Brekenfeld on 22.01.14.
//
//

#import "UDPMoveEntity.h"
#import "OFDataArray+IntReader.h"
#import "OFDataArray+IntWriter.h"
#import "OFDataArray+FloatReader.h"
#import "OFDataArray+FloatWriter.h"

@implementation UDPMoveEntity

- (id)initWithEntity:(MovingEntity *)entity {
    self = [super init];
    if (self) {
        self.entityId = [entity entityId];
        self.X = (float)entity.X;
        self.Y = (float)entity.Y;
        self.Z = (float)entity.Z;
        self.Yaw = entity.Yaw;
        self.Pitch = entity.Pitch;
    }
    return self;
}

- (id)initWithData:(NSData *)data {
    self = [super init];
    if (self) {
        NSMutableData *packetData = [data mutableCopy];
        self.entityId = [packetData readInt];
        
        self.X = [packetData readFloat];
        self.Y = [packetData readFloat];
        self.Z = [packetData readFloat];
        self.Yaw = [packetData readFloat];
        self.Pitch = [packetData readFloat];
    }
    return self;
}

+ (uint8_t)packetId {
    return 0x90;
}

- (NSData *)packetData {
    NSMutableData *packetData = [[NSMutableData alloc] init];
    [packetData appendInt:self.entityId];
    [packetData appendFloat:self.X];
    [packetData appendFloat:self.Y];
    [packetData appendFloat:self.Z];
    [packetData appendFloat:self.Yaw];
    [packetData appendFloat:self.Pitch];
    return packetData;
}

@end
