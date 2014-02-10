//
//  ChunkManager.h
//  MinecraftServer
//
//  Created by Victor Brekenfeld on 30.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import <ObjFW/ObjFW.h>
@class Chunk;
@class ChunkColumn;
@class WorldGenerator;

@interface ChunkManager : OFObject {
    OFMapTable *loadedChunks; //weak reference table to access all already loaded chunks
    WorldGenerator *generator;
}

- (instancetype)initWithGenerator:(WorldGenerator *)generator;
- (Chunk *)getChunkAtX:(int32_t)x AtY:(int32_t)y AtZ:(int32_t)z;
- (void)unloadChunk:(Chunk *)chunk;

@end

void *vector_retain(void *vector);
void vector_release(void *vector);
bool vectors_equal (void *vec1, void *vec2);
uint32_t vector_hash (void *vector);