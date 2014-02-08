//
//  OverworldGenerator.m
//  MinecraftServer
//
//  Created by Victor Brekenfeld on 27.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "OverworldGenerator.h"
#import "Chunk.h"
#import "AirBlock.h"
#import "DirtBlock.h"

@implementation OverworldGenerator

- (Chunk *)generatedChunkAtX:(int32_t)x AtY:(int32_t)height AtZ:(int32_t)z {
    
    //SUPERFLAT
    
    OFMutableArray *blocks = [[OFMutableArray alloc] init];
    for (int8_t x = 0; x<16; x++) {
        OFMutableArray *yArray = [[[OFMutableArray alloc] init] autorelease];
        for (int8_t y = 0; y<16; y++) {
            OFMutableArray *zArray = [[[OFMutableArray alloc] init] autorelease];
            for (int8_t z = 0; z<16; z++) {
                if (y+(height*16) < 64) {
                    [zArray addObject:[[DirtBlock alloc] init]];
                }
                else
                    [zArray addObject:[[AirBlock alloc] init]];
            }
            [yArray addObject:zArray];
        }
        [blocks addObject:yArray];
    }
    
    Chunk *chunk = [[Chunk alloc] initWithBlocks:[blocks autorelease]];
    vector position = { x, height, z };
    chunk.position = position;
    return chunk;
}

@end
