//
//  TCPLoginPacket.h
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 06.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//


#import <ObjFW/ObjFW.h>
#import "TCPServerPacket.h"
#import "Player.h"

@interface TCPJoinGame : TCPServerPacket

@property (nonatomic) int32_t entityId;
@property (nonatomic) uint8_t gamemode;
@property (nonatomic) int8_t dimension;
@property (nonatomic) uint8_t difficulty;
@property (nonatomic) uint8_t maxPlayers;
@property (nonatomic, retain) OFString *levelType;

- (instancetype)initWithPlayer:(Player *)player forGamemode:(uint8_t)gamemode isHardcore:(bool)hardcore forDifficulty:(uint8_t)difficulty forMaxPlayers:(uint8_t)maxPlayers forLevelType:(OFString *)levelType;

@end
