//
//  Player.h
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 06.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "LivingEntity.h"
@class Chunk;
@class ChunkColumn;
@class ChunkManager;
@class World;

@interface Player : LivingEntity {
    OFMutableSet *loadedChunks;
    World *world;
    ChunkManager *worldChunkManager;
    
    OFMapTable *lastAgeRequests;
}

@property (atomic) double headY;
@property (atomic) double feetY;
@property (atomic) BOOL isCreativeMode;

+ (Player *)spawnPlayerWithUsername:(OFString *)username;

- (int32_t)chunkPosX;
- (int32_t)chunkPosY;
- (int32_t)chunkPosZ;

@property (nonatomic) uint64_t clientId;
@property (nonatomic, retain) OFString *username;

+ (int)playerCount;

- (BOOL)isChunkDirtyAtX:(int32_t)x AtY:(int32_t)y AtZ:(int32_t)z;
- (BOOL)isChunkDirty:(Chunk *)chunk;
- (Chunk *)loadChunkAtX:(int32_t)x AtY:(int32_t)y AtZ:(int32_t)z;
- (ChunkColumn *)loadChunkColumnAtX:(int32_t)x AtZ:(int32_t)z;
- (void)unloadChunk:(Chunk *)chunk;
- (void)unloadChunkAtX:(int32_t)x AtY:(int32_t)y AtZ:(int32_t)z;
- (void)unloadChunkColumn:(ChunkColumn *)chunkColumn;
- (void)unloadChunkColumnAtX:(int32_t)x AtZ:(int32_t)z;

@end
