//
//  UDPAddPlayer.m
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 20.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "UDPAddPlayer.h"
#import "Player.h"
#import "OFDataArray+IntReader.h"
#import "OFDataArray+IntWriter.h"
#import "OFDataArray+FloatReader.h"
#import "OFDataArray+FloatWriter.h"
#import "OFDataArray+StringReader.h"
#import "OFDataArray+StringWriter.h"

@implementation UDPAddPlayer
@synthesize clientID, username, entityId, X, Y, Z, Yaw, Pitch, unknown, unknown2, metadata;

- (id)initWithPlayer:(Player *)player {
    self = [super init];
    @try {
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
        self.metadata = [OFDataArray dataArray];
        [self.metadata appendByte:0x00];
    } @catch (id e) {
        [self release];
        @throw e;
    }
    return self;
}

- (id)initWithData:(OFDataArray *)data {
    self = [super init];
    @try {
        self.clientID = [data readLong];
        self.username = [data readStringUdp];
        self.entityId = [data readInt];
        
        self.X = [data readFloat];
        self.Y = [data readFloat];
        self.Z = [data readFloat];
        self.Yaw = [data readFloat];
        self.Pitch = [data readFloat];
        
        self.unknown = [data readShort];
        self.unknown2 = [data readShort];
    } @catch (id e) {
        [self release];
        @throw e;
    }
    return self;
}

+ (uint8_t)packetId {
    return 0x89;
}

- (OFDataArray *)packetData {
    OFDataArray *packetData = [OFDataArray dataArray];
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
    [packetData addItems:[self.metadata items] count:[self.metadata count]];
    return packetData;
}

@end
