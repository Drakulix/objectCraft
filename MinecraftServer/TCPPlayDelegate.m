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
    
    connectionDelegate = [client retain];
    player = _player;
    
    TCPInitMapChunks *chunkPacket = nil;
    @try {
       
        ConfigManager *config = [ConfigManager defaultManager];
        @autoreleasepool {
            [connectionDelegate sendPacket:[[[TCPJoinGame alloc] initWithPlayer:player
                                                                   forGamemode:config.defaultGamemode
                                                                    isHardcore:config.isHardcore
                                                                 forDifficulty:config.difficulty
                                                                 forMaxPlayers:config.maxPlayers
                                                                  forLevelType:@"default"] autorelease]];
        }
        @autoreleasepool {
            [connectionDelegate sendPacket:[[[TCPCustomPayload alloc] initWithChannel:@"MC|Brand" payload:[@"ObjectCraft" dataUsingEncoding:OF_STRING_ENCODING_UTF_8]] autorelease]];
        }
        
        //and now(!) CHUNKS
        
        chunkPacket = [[TCPInitMapChunks alloc] initForTcpDimension:player.tcpDimension];
        for (int x = player.chunkPosX-4; x<=player.chunkPosX+4; x++) {
            for (int z = player.chunkPosZ-4; z<=player.chunkPosZ+4; z++) {
                [chunkPacket addChunkColumn:[player loadChunkColumnAtX:x AtZ:z]];
            }
        }
        [connectionDelegate sendPacket:chunkPacket];
        [chunkPacket release];
        chunkPacket = nil;
        
        player.Yaw = 0.0f;
        player.Pitch = 0.0f;
        player.OnGround = YES;
        
        //Overwrite for testing
        player.isCreativeMode = YES;
        player.canFly = YES;
        player.isFlying = YES;
        
        @autoreleasepool {
            [connectionDelegate sendPacket:[[[TCPSpawnPosition alloc] initWithX:[player blockPosX] withY:[player blockPosY] withZ:[player blockPosZ]] autorelease]];
        }
        @autoreleasepool {
            [connectionDelegate sendPacket:[[[TCPPlayerAbilities alloc] initWithPlayer:player] autorelease]];
        }
        
        //To-Do's
        //BlockItemSwitch
        //Scoreboard
        
        @autoreleasepool {
            [connectionDelegate sendPacket:[[[TCPTimeUpdate alloc] initWithAge:5 andDayTime:6000] autorelease]];
        }
        @autoreleasepool {
            [connectionDelegate sendPacket:[[[TCPPlayerPositionAndLookServer alloc] initWithPlayer:player] autorelease]];
        }
        
        //Weather (if needed)
        //Chat 'Player Spawned'
        
        //optional: Texture Pack, Potion Effects, Riding
        
        //Inventory (window packet)
        
    }
    @catch (id e) {
        [chunkPacket release];
        [self release];
        @throw e;
    }

    return self;
}

- (void)recievedPacket:(TCPPacket *)packet {
    if ([packet isKindOfClass:[TCPPlayerPositionAndLookClient class]]) {
        TCPPlayerPositionAndLookClient *posPacket = (TCPPlayerPositionAndLookClient *)packet;
        player.X = posPacket.X;
        player.feetY = posPacket.FeetY;
        player.headY = posPacket.HeadY;
        player.Z = posPacket.Z;
        player.OnGround = posPacket.OnGround;
        player.Yaw = posPacket.Yaw;
        player.Pitch = posPacket.Pitch;
        LogVerbose(@"Client Position: %@", posPacket);
    }
    if ([packet isKindOfClass:[TCPPlayerPositionClient class]]) {
        TCPPlayerPositionClient *posPacket = (TCPPlayerPositionClient *)packet;
        player.X = posPacket.X;
        player.feetY = posPacket.feetY;
        player.headY = posPacket.headY;
        player.Z = posPacket.Z;
        player.OnGround = posPacket.OnGround;
        LogVerbose(@"Client Position: %@", posPacket);
    }
}

- (void)clientDisconnected {
    [player despawn];
}

- (int)state {
    return 3;
}

- (void)dealloc {
    [connectionDelegate release];
    [super dealloc];
}

@end