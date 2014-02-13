//
//  TCPLoginPacket.m
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 06.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "TCPJoinGame.h"
#import "OFDataArray+IntWriter.h"
#import "OFDataArray+StringWriter.h"

@implementation TCPJoinGame
@synthesize entityId, gamemode, dimension, difficulty, maxPlayers, levelType;

- (instancetype)initWithPlayer:(Player *)player forGamemode:(uint8_t)_gamemode isHardcore:(bool)hardcore forDifficulty:(uint8_t)_difficulty forMaxPlayers:(uint8_t)_maxPlayers forLevelType:(OFString *)_levelType {
    self = [super init];
    @try {
        self.entityId = player.entityId;
        self.gamemode = _gamemode;
        self.gamemode |= hardcore << 3;
        self.difficulty = _difficulty;
        self.maxPlayers = _maxPlayers;
        self.levelType = _levelType;
    } @catch (id e) {
        [self release];
        @throw e;
    }
    return self;
}

+ (uint64_t)packetId {
    return 0x01;
}

- (OFDataArray *)packetData {
    OFDataArray *packetData = [OFDataArray dataArray];
    [packetData appendInt:self.entityId];
    [packetData appendUnsignedByte:self.gamemode];
    [packetData appendByte:self.dimension];
    [packetData appendUnsignedByte:self.difficulty];
    [packetData appendUnsignedByte:self.maxPlayers];
    [packetData appendStringTcp:self.levelType];
    return packetData;
}

@end
