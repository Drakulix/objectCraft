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

- (instancetype)initWithPlayer:(Player *)player forGamemode:(uint8_t)gamemode isHardcore:(BOOL)hardcore forDifficulty:(uint8_t)difficulty forMaxPlayers:(uint8_t)maxPlayers forLevelType:(OFString *)levelType {
    self = [super init];
    @try {
        self.entityId = player.entityId;
        self.gamemode = gamemode;
        self.gamemode |= hardcore << 3;
        self.difficulty = difficulty;
        self.maxPlayers = maxPlayers;
        self.levelType = levelType;
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
