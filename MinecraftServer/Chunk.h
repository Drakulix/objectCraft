//
//  Chunk.h
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 06.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import <ObjFW/ObjFW.h>
@class Block;

typedef struct {
    int32_t X;
    int32_t Y;
    int32_t Z;
} vector;

@interface Chunk : OFObject {
    OFMutableArray *blocks;
    int16_t loadCount;
}

@property (nonatomic) vector position;
@property (atomic) int64_t ageInTicks;
@property bool isEmpty;

- (id)initWithBlocks:(OFMutableArray *)array;
- (Block *)blockAtX:(int16_t)x Y:(int16_t)y Z:(int16_t)z;

- (int16_t)load;
- (int16_t)unload;


@end

void *chunk_retain(void *value);
void chunk_release(void *value);
uint32_t chunk_hash(void *value);
bool chunk_equal(void *value1, void *value2);