//
//  Chunk.m
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 06.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "Chunk.h"
#import "ChunkManager.h"
#import "Block.h"

@implementation Chunk
@synthesize position, ageInTicks, isEmpty;

- (id)initWithBlocks:(OFMutableArray *)array {
    self = [super init];
    @try {
        blocks = [array retain];
        self.isEmpty = false;
        self.ageInTicks = 0;
        loadCount = 0;
        [self updateIsEmpty];
    } @catch (id e) {
        [self release];
        @throw e;
    }
    return self;
}

- (void)dealloc {
    [blocks release];
    [super dealloc];
}

- (Block *)blockAtX:(int16_t)x Y:(int16_t)y Z:(int16_t)z {
    return blocks[x][y][z];
}

- (void)updateIsEmpty {
    self.isEmpty = [self updateIsEmptyHelper];
}

- (bool)updateIsEmptyHelper {
    for (int x = 0; x<16; x++) {
        for (int y = 0; y<16; y++) {
            for (int z = 0; z<16; z++) {
                if ([blocks[x][y][z] tcpBlockId] != 0) {
                    return false;
                }
            }
        }
    }
    return true;
}


- (int16_t)load {
    return ++loadCount;
}
- (int16_t)unload {
    return --loadCount;
}

- (uint32_t)hash {
    return chunk_hash(self);
}

- (bool)isEqual:(id)object {
    if ([object isKindOfClass:[Chunk class]])
        return chunk_equal(self, object);
    return false;
}


void *chunk_retain(void *value) {
    return value; //do not retain chunks in ofmaptable!
}

void chunk_release(void *value) {}

uint32_t chunk_hash(void *value) {
    vector vec = ((Chunk *) value).position;
    return vector_hash(&vec);
}

bool chunk_equal(void *value1, void *value2) {
    vector vec1 = ((Chunk *) value1).position;
    vector vec2 = ((Chunk *) value2).position;
    return vectors_equal(&vec1, &vec2);
}

@end
