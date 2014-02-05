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

@property int32_t entityId;
@property uint8_t gamemode;
@property int8_t dimension;
@property uint8_t difficulty;
@property uint8_t maxPlayers;
@property (retain) OFString *levelType;

- (instancetype)initWithPlayer:(Player *)player forGamemode:(uint8_t)gamemode isHardcore:(BOOL)hardcore forDifficulty:(uint8_t)difficulty forMaxPlayers:(uint8_t)maxPlayers forLevelType:(OFString *)levelType;

@end
