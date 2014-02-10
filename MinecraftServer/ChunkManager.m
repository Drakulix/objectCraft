//
//  ChunkManager.m
//  MinecraftServer
//
//  Created by Victor Brekenfeld on 30.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "ChunkManager.h"
#import "ChunkColumn.h"
#import "Chunk.h"
#import "WorldGenerator.h"
#import <string.h>

void *vector_retain(void *vec) {
    void *buffer = malloc(sizeof(vector));
    memcpy(buffer, vec, sizeof(vector));
    return buffer;
}

void vector_release(void *vec) {
    free(vec);
}

bool vectors_equal (void *vec1, void *vec2) {
    return ((*((vector *)vec1)).X == (*((vector *)vec2)).X) && ((*((vector *)vec1)).Y == (*((vector *)vec2)).Y) && ((*((vector *)vec1)).Z == (*((vector *)vec2)).Z);
}

uint32_t vector_hash (void *vec) {
    return ((*((vector *)vec)).X * 73856093) + ((*((vector *)vec)).Y * 19349663) + ((*((vector *)vec)).Z * 83492791); //TO-DO make and test possibly better hash functions
}



@implementation ChunkManager

- (instancetype)initWithGenerator:(WorldGenerator *)_generator {
    self = [super init];
    @try {
        of_map_table_functions_t vectorFunctions;
        vectorFunctions.retain = vector_retain;
        vectorFunctions.release = vector_release;
        vectorFunctions.hash = vector_hash;
        vectorFunctions.equal = vectors_equal;
        
        of_map_table_functions_t chunkFunctions;
        chunkFunctions.retain = chunk_retain;
        chunkFunctions.release = chunk_release;
        chunkFunctions.hash = chunk_hash;
        chunkFunctions.equal = chunk_equal;
        
        loadedChunks = [[OFMapTable alloc] initWithKeyFunctions:vectorFunctions valueFunctions:chunkFunctions];
        generator = [_generator retain];
    } @catch (id e) {
        [self release];
        @throw e;
    }
    return self;
}

- (void)dealloc {
    [loadedChunks release];
    [generator release];
    [super dealloc];
}

- (ChunkColumn *)getChunkColumnAtX:(int32_t)x AtZ:(int32_t)z {
    ChunkColumn *column = [[ChunkColumn alloc] init];
    column.X = x;
    column.Z = z;
    for (int y = 0; y < 16; y++) {
        [column.chunks addObject:[self getChunkAtX:x AtY:y AtZ:z]];
    }
    return [column autorelease];
}

- (Chunk *)getChunkAtX:(int32_t)x AtY:(int32_t)y AtZ:(int32_t)z {
    vector chunkPos = {x, y, z};
    
    if ([loadedChunks valueForKey:&chunkPos] != nil)
        return [loadedChunks valueForKey:&chunkPos];
    
    //To-Do load from save
    
    
    //if loading fails -> generate (and save again)
    Chunk *chunk = [generator generatedChunkAtX:x AtY:y AtZ:z];
    chunk.position = chunkPos;
    [loadedChunks setValue:chunk forKey:&chunkPos];
    return chunk;
}

- (void)unloadChunk:(Chunk *)chunk {
    vector chunkPos = chunk.position;
    [loadedChunks removeValueForKey:&chunkPos];
}

@end
