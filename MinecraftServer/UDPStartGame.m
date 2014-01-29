//
//  UDPStartGamePacket.m
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 10.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "UDPStartGame.h"
#import "ConfigManager.h"

@implementation UDPStartGame

- (instancetype)initWithPlayer:(Player *)player {
    self = [super init];
    if (self) {
        self.seed = [ConfigManager defaultManager].seed;
        self.generator = 0;
        self.gamemode = 1;//[ConfigManager sharedInstance].gamemode;
        self.entityId = player.entityId;
        self.X = (float)player.X;
        self.Y = (float)player.Y-64.0;
        self.Z = (float)player.Z;
    }
    return self;
}

- (instancetype)initWithData:(NSData *)data {
    self = [super init];
    if (self) {
        NSMutableData *packetData = [data mutableCopy];
        self.seed = [packetData readInt];
        self.generator = [packetData readInt];
        self.gamemode = [packetData readInt];
        self.entityId = [packetData readInt];
        self.X = [packetData readFloat];
        self.Y = [packetData readFloat];
        self.Z = [packetData readFloat];
    }
    return self;
}

+ (uint8_t)packetId {
    return 0x87;
}

- (NSData *)packetData {
    NSMutableData *packetData = [[NSMutableData alloc] init];
    
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
