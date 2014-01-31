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

- (instancetype)init {
    self = [super init];
    if (self) {
        _chunks = [[OFMutableArray alloc] init];
    }
    return self;
}

@end
