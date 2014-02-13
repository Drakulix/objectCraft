//
//  ChunkColumn.m
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 06.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "ChunkColumn.h"
#import "Chunk.h"

@implementation ChunkColumn
@synthesize X, Z;

- (instancetype)init {
    return [super init];
}

- (void)setChunk:(Chunk *)chunk atIndex:(int)index {
    chunks[index] = chunk;
}

- (Chunk *)chunkAtIndex:(int)index {
    return chunks[index];
}

- (int)chunkCount {
    return 16;
}

@end
