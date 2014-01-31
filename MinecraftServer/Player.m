//
//  Player.m
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 06.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "log.h"
#import "Player.h"
#import "WorldManager.h"
#import "World.h"
#import "EntityManager.h"
#import "ConfigManager.h"
#import "ChunkManager.h"
#import "ChunkColumn.h"
#import "Chunk.h"
#import <string.h>

int playerCount;

@implementation Player

- (instancetype)initSpawnPlayerWithUsername:(NSString *)username {
    self = (Player *)[[[WorldManager defaultManager] worldForDimension:[ConfigManager defaultManager].spawnDimension].entityManager addEntityOfClass:[Player class]];
    if (self) {
        self.username = username;
        self.canBeDamaged = YES;
        self.canFly = NO;
        self.isFlying = NO;
        self.isCreativeMode = YES;
        self.walkingSpeed = 0.1f;
        self.flyingSpeed = 0.2f;
        self.clientId = self.entityId;
        
        playerCount++;
        
        //TO-DO load player save - save player stats on World unloading
        
        //To-Do get default SpawnPoint, when no save exists - get top most Y for default spawn point
        self.X = 0.0;
        self.Y = 64.0;
        self.Z = 0.0;
        
        loadedChunks = [[OFMutableSet alloc] init];
        world = [[WorldManager defaultManager] worldForDimension:self.dimension];
        worldChunkManager = world.chunkManager;
        
        of_map_table_functions_t chunkFunctions;
        chunkFunctions.retain = chunk_retain;
        chunkFunctions.release = chunk_release;
        chunkFunctions.hash = chunk_hash;
        chunkFunctions.equal = chunk_equal;
        
        of_map_table_functions_t uint64Functions;
        uint64Functions.retain = uint64_retain;
        uint64Functions.release = uint64_release;
        uint64Functions.hash = uint64_hash;
        uint64Functions.equal = uint64_equal;
        
        lastAgeRequests = [[OFMapTable alloc] initWithKeyFunctions:chunkFunctions valueFunctions:uint64Functions];

    }
    return self;
}


- (int32_t)chunkPosX {
    return [self blockPosX]/16;
}
- (int32_t)chunkPosY {
    return [self blockPosY]/16;
}
- (int32_t)chunkPosZ {
    return [self blockPosZ]/16;
}

- (void)dealloc {
    playerCount--;
    [super dealloc];
}

+ (int)playerCount {
    return playerCount;
}

- (BOOL)isChunkDirtyAtX:(int32_t)x AtY:(int32_t)y AtZ:(int32_t)z { //Do chunk needs update
    Chunk *chunk = [worldChunkManager getChunkAtX:x AtY:y AtZ:z];
    if ([loadedChunks containsObject:chunk] && chunk.ageInTicks <= *(uint64_t *)[lastAgeRequests valueForKey:chunk]) {
        return NO;
    }
    return YES;
}
- (BOOL)isChunkDirty:(Chunk *)chunk {
    if ([loadedChunks containsObject:chunk] && chunk.ageInTicks <= *(uint64_t *)[lastAgeRequests valueForKey:chunk]) {
        return NO;
    }
    return YES;
}

- (Chunk *)loadChunkAtX:(int32_t)x AtY:(int32_t)y AtZ:(int32_t)z {
    Chunk *loadedChunk = [worldChunkManager getChunkAtX:x AtY:y AtZ:z];
    [loadedChunks addObject:loadedChunk];
    uint64_t age = loadedChunk.ageInTicks;
    [lastAgeRequests setValue:&age forKey:loadedChunk];
    return loadedChunk;
}

- (ChunkColumn *)loadChunkColumnAtX:(int32_t)x AtZ:(int32_t)z {
    ChunkColumn *column = [[ChunkColumn alloc] init];
    column.X = x;
    column.Z = z;
    for (int i = 0; i < 16; i++) {
        Chunk *chunk = [worldChunkManager getChunkAtX:x AtY:i AtZ:z];
        [column.chunks addObject:chunk];
        [loadedChunks addObject:chunk];
        uint64_t age = chunk.ageInTicks;
        [lastAgeRequests setValue:&age forKey:chunk];
    }
    return column;
}

- (void)unloadChunk:(Chunk *)chunk {
    [lastAgeRequests removeValueForKey:chunk];
    [loadedChunks removeObject:chunk];
}
- (void)unloadChunkAtX:(int32_t)x AtY:(int32_t)y AtZ:(int32_t)z {
    Chunk *loadedChunk = [worldChunkManager getChunkAtX:x AtY:y AtZ:z]; //no real overhead, object should still be available in the global cache
    [lastAgeRequests removeValueForKey:loadedChunk];
    [loadedChunks removeObject:loadedChunk];
}

- (void)unloadChunkColumn:(ChunkColumn *)chunkColumn {
    for (Chunk *chunk in chunkColumn.chunks) {
        [lastAgeRequests removeValueForKey:chunk];
        [loadedChunks removeObject:chunk];
    }
}
- (void)unloadChunkColumnAtX:(int32_t)x AtZ:(int32_t)z {
    for (int i = 0; i < 16; i++) {
        Chunk *chunk = [worldChunkManager getChunkAtX:x AtY:i AtZ:z];
        [lastAgeRequests removeValueForKey:chunk];
        [loadedChunks removeObject:chunk];
    }
}

void *uint64_retain(void *uint64) {
    void *buf = malloc(sizeof(uint64_t));
    memcpy(buf, uint64, sizeof(uint64_t));
    return buf;
}

void uint64_release(void *uint64) {
    free(uint64);
}

bool uint64_equal (void *uint641, void *uint642) {
    return (*(uint64_t *)uint641) == (*(uint64_t *)uint642);
}

uint32_t uint64_hash (void *uint64) {
    return (*(uint64_t *)uint64) % UINT32_MAX;
}

@end

