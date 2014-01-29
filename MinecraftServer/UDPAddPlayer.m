//
//  UDPAddPlayer.m
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 20.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "UDPAddPlayer.h"
#import "OFDataArray+IntReader.h"
#import "OFDataArray+IntWriter.h"
#import "OFDataArray+FloatReader.h"
#import "OFDataArray+FloatWriter.h"

@implementation UDPAddPlayer

- (id)initWithPlayer:(Player *)player {
    self = [super init];
    if (self) {
        self.clientID = [player clientId];
        self.username = [player username];
        self.entityId = [player entityId];
        self.X = (float)player.X;
        self.Y = (float)player.Y;
        self.Z = (float)player.Z;
        self.Yaw = player.Yaw;
        self.Pitch = player.Pitch;
        self.unknown = 0;
        self.unknown2 = 0;
        self.metadata = [[OFDataArray alloc] init];
        [self.metadata appendByte:0x00];
    }
    return self;
}

- (id)initWithData:(NSData *)data {
    self = [super init];
    if (self) {
        NSMutableData *packetData = [data mutableCopy];
        self.clientID = [packetData readLong];
        self.username = [packetData readStringUdp];
        self.entityId = [packetData readInt];
        
        self.X = [packetData readFloat];
        self.Y = [packetData readFloat];
        self.Z = [packetData readFloat];
        self.Yaw = [packetData readFloat];
        self.Pitch = [packetData readFloat];
        
        self.unknown = [packetData readShort];
        self.unknown2 = [packetData readShort];
    }
    return self;
}

+ (uint8_t)packetId {
    return 0x89;
}

- (NSData *)packetData {
    NSMutableData *packetData = [[NSMutableData alloc] init];
    [packetData appendLong:self.clientID];
    [packetData appendStringUdp:self.username];
    [packetData appendInt:self.entityId];
    [packetData appendFloat:self.X];
    [packetData appendFloat:self.Y];
    [packetData appendFloat:self.Z];
    [packetData appendFloat:self.Yaw];
    [packetData appendFloat:self.Pitch];
    [packetData appendShort:self.unknown];
    [packetData appendShort:self.unknown2];
    [packetData appendData:self.metadata];
    return packetData;
}

@end
