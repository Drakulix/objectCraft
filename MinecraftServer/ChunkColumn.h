//
//  ChunkColumn.h
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 06.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import <ObjFW/ObjFW.h>
@class Chunk;

@interface ChunkColumn : OFObject {
    Chunk *chunks[16];
}

@property int32_t X;
@property int32_t Z;

- (int)chunkCount;
- (Chunk *)chunkAtIndex:(int)index;
- (void)setChunk:(Chunk *)chunk atIndex:(int)index;

@end