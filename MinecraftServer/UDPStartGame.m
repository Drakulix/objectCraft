//
//  UDPStartGamePacket.m
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 10.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "UDPStartGame.h"
#import "ConfigManager.h"
#import "Player.h"

#import "OFDataArray+IntReader.h"
#import "OFDataArray+IntWriter.h"
#import "OFDataArray+FloatReader.h"
#import "OFDataArray+FloatWriter.h"

@implementation UDPStartGame

- (instancetype)initWithPlayer:(Player *)player {
    self = [super init];
    @try {
        self.seed = [ConfigManager defaultManager].seed;
        self.generator = 0;
        self.gamemode = 1;//[ConfigManager sharedInstance].gamemode;
                          //To-Do remove that testing overwrite
        self.entityId = player.entityId;
        
        self.X = (float)player.X+0.5f;
        self.Y = (float)player.Y;
        self.Z = (float)player.Z+0.5f;
        
    } @catch (id e) {
        [self release];
        @throw e;
    }
    return self;
}

- (instancetype)initWithData:(OFDataArray *)data {
    self = [super init];
    @try {
        self.seed = [data readInt];
        self.generator = [data readInt];
        self.gamemode = [data readInt];
        self.entityId = [data readInt];
        self.X = [data readFloat];
        self.Y = [data readFloat];
        self.Z = [data readFloat];
    } @catch (id e) {
        [self release];
        @throw e;
    }
    return self;
}

+ (uint8_t)packetId {
    return 0x87;
}

- (OFDataArray *)packetData {
    OFDataArray *packetData = [OFDataArray dataArray];
    
    [packetData appendInt:self.seed];
    [packetData appendInt:self.generator];
    [packetData appendInt:self.gamemode];
    [packetData appendInt:self.entityId];
    
    [packetData appendFloat:self.X];
    [packetData appendFloat:self.Y];
    [packetData appendFloat:self.Z];
    
    return packetData;
}

@end
