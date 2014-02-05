//
//  TCPPlayDelegate.m
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 05.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "log.h"

#import "TCPPlayDelegate.h"
#import "TCPClientConnection.h"
#import "Player.h"

#import "TCPJoinGame.h"
#import "TCPCustomPayload.h"
#import "TCPSpawnPosition.h"
#import "TCPPlayerAbilities.h"
#import "TCPInitMapChunks.h"
#import "TCPPlayerPositionClient.h"
#import "TCPPlayerPositionAndLookClient.h"
#import "TCPPlayerPositionAndLookServer.h"
#import "TCPTimeUpdate.h"

#import "ConfigManager.h"
#import "WorldManager.h"

#import "OFString+DataUsingEncoding.h"

@implementation TCPPlayDelegate

- (instancetype)initWithClientConnection:(TCPClientConnection *)client withPlayer:(Player *)_player {
    self = [super init];
    if (self) {
        connectionDelegate = client;
        player = _player;
        
        ConfigManager *config = [ConfigManager defaultManager];
        [connectionDelegate sendPacket:[[TCPJoinGame alloc] initWithPlayer:player
                                                           forGamemode:config.defaultGamemode
                                                            isHardcore:config.isHardcore
                                                         forDifficulty:config.difficulty
                                                         forMaxPlayers:config.maxPlayers
                                                          forLevelType:@"default"]];
        [connectionDelegate sendPacket:[[TCPCustomPayload alloc] initWithChannel:@"MC|Brand" payload:[@"ObjectCraft" dataUsingEncoding:OF_STRING_ENCODING_UTF_8]]];
        
        //and now(!) CHUNKS
        TCPInitMapChunks *chunkPacket = [[TCPInitMapChunks alloc] initForDimension:player.dimension];
        for (int x = player.chunkPosX-4; x<=player.chunkPosX+4; x++) {
            for (int z = player.chunkPosZ-4; z<=player.chunkPosZ+4; z++) {
                [chunkPacket addChunkColumn:[player loadChunkColumnAtX:x AtZ:z]];
            }
        }
        [connectionDelegate sendPacket:chunkPacket];
        
        player.Yaw = 0.0f;
        player.Pitch = 0.0f;
        player.Stance = 0.1;
        player.OnGround = YES;
        
        //Overwrite for testing
        player.isCreativeMode = YES;
        player.canFly = YES;
        player.isFlying = YES;
        
        
        [connectionDelegate sendPacket:[[TCPSpawnPosition alloc] initWithX:[player blockPosX] withY:[player blockPosY] withZ:[player blockPosZ]]];
        [connectionDelegate sendPacket:[[TCPPlayerAbilities alloc] initWithPlayer:player]];
        //To-Do's
        //BlockItemSwitch
        //Scoreboard
        [connectionDelegate sendPacket:[[TCPTimeUpdate alloc] initWithAge:5 andDayTime:6000]];
        [connectionDelegate sendPacket:[[TCPPlayerPositionAndLookServer alloc] initWithPlayer:player]];
        //Weather (if needed)
        //Chat 'Player Spawned'
        
        //optional: Texture Pack, Potion Effects, Riding
        
        //Inventory (window packet)
        
    }
    return self;
}

- (void)recievedPacket:(TCPPacket *)packet {
    if ([packet isKindOfClass:[TCPPlayerPositionAndLookClient class]]) {
        TCPPlayerPositionAndLookClient *posPacket = (TCPPlayerPositionAndLookClient *)packet;
        player.X = 0.0;
        player.Y = player.Y;
        if (player.Y < 65.0)
            player.Y = 65.0;
        player.Z = 0.0;
        player.OnGround = true;
        player.Yaw = posPacket.Yaw;
        player.Pitch = posPacket.Pitch;
        LogVerbose(@"Client Position: %@", posPacket);
    }
    if ([packet isKindOfClass:[TCPPlayerPositionClient class]]) {
        TCPPlayerPositionClient *posPacket = (TCPPlayerPositionClient *)packet;
        player.X = posPacket.X;
        player.Y = posPacket.Y;
        player.Z = posPacket.Z;
        player.OnGround = posPacket.OnGround;
        LogVerbose(@"Client Position: %@", posPacket);
    }
}

- (void)clientDisconnected {
    
}

- (int)state {
    return 3;
}

@end