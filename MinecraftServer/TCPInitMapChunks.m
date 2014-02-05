//
//  TCPInitMapChunks.m
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 06.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "TCPInitMapChunks.h"
#import "ChunkColumn.h"
#import "Chunk.h"
#import "Block.h"
#import "OFDataArray+ZLib.h"
#import "OFDataArray+IntWriter.h"

//#define TEST

@implementation TCPInitMapChunks

- (instancetype)initForDimension:(int8_t)dimension {
    self = [super init];
    if (self) {
        self.skyLightSend = (dimension == 0);
        chunkColumns = [[OFMutableArray alloc] init];
    }
    return self;
}

- (void)addChunkColumn:(ChunkColumn *)chunk {
    [chunkColumns addObject:chunk];
}

+ (uint64_t)packetId {
    return 0x26;
}

- (OFDataArray *)packetData {
    OFDataArray *packetData = [[OFDataArray alloc] init];
    [packetData appendShort:[chunkColumns count]];
    
    OFDataArray *chunkColumnsData = [[OFDataArray alloc] init];
    OFDataArray *chunkColumnsDataZipped = [[OFDataArray alloc] init];
    
    int chunkCounter = 0;
    
    for (int i = 0; i<[chunkColumns count]; i++) {
        
        ChunkColumn *chunkColumn = [chunkColumns objectAtIndex:i];
        
        [chunkColumnsData appendInt:chunkColumn.X];
        [chunkColumnsData appendInt:chunkColumn.Z];
        
        int16_t primaryBitMask = 0;
        for (int j = 0; j<[chunkColumn.chunks count]; j++) {
            if (!((Chunk *)[chunkColumn.chunks objectAtIndex:j]).isEmpty) {
                primaryBitMask |= 1 << j;
            }
        }
        
        int16_t addBitMask = 0;
        //currently nothing to "add"
        /*for (int j = 0; j<16; j++) {
            addBitMask |= 1 << j;
        }*/
        [chunkColumnsData appendShort:primaryBitMask];
        [chunkColumnsData appendShort:addBitMask];
        
        for (int j = 0; j<[chunkColumn.chunks count]; j++) {
            Chunk *chunk = (Chunk *)[chunkColumn.chunks objectAtIndex:j];
            if (!chunk.isEmpty) {
                chunkCounter++;
                for (int y = 0; y<[chunkColumn.chunks count]; y++) {
                    for (int z = 0; z<[chunkColumn.chunks count]; z++) {
                        for (int x = 0; x<[chunkColumn.chunks count]; x++) {
                            [chunkColumnsDataZipped appendUnsignedByte:[[chunk blockAtX:x Y:y Z:z] tcpBlockId]];
                        }
                    }
                }
            }
        }
        
        for (int j = 0; j<[chunkColumn.chunks count]; j++) {
            Chunk *chunk = (Chunk *)[chunkColumn.chunks objectAtIndex:j];
            if (!chunk.isEmpty) {
                for (int y = 0; y<[chunkColumn.chunks count]; y++) {
                    for (int z = 0; z<[chunkColumn.chunks count]; z++) {
                        for (int x = 0; x<[chunkColumn.chunks count]; x+=2) {
                            Nibbler nibb;
                            nibb.nibbles.first = [[chunk blockAtX:x Y:y Z:z] tcpMetadata];
                            nibb.nibbles.second = [[chunk blockAtX:x+1 Y:y Z:z] tcpMetadata];
                            [chunkColumnsDataZipped appendNibbler:nibb];
                        }
                    }
                }
            }
        }
        
        for (int j = 0; j<[chunkColumn.chunks count]; j++) {
            Chunk *chunk = (Chunk *)[chunkColumn.chunks objectAtIndex:j];
            if (!chunk.isEmpty) {
                for (int y = 0; y<[chunkColumn.chunks count]; y++) {
                    for (int z = 0; z<[chunkColumn.chunks count]; z++) {
                        for (int x = 0; x<[chunkColumn.chunks count]; x+=2) {
                            Nibbler nibb;
                            nibb.nibbles.first = [[chunk blockAtX:x Y:y Z:z] tcpLightEmit];
                            nibb.nibbles.second = [[chunk blockAtX:x+1 Y:y Z:z] tcpLightEmit];
                            [chunkColumnsDataZipped appendNibbler:nibb];
                        }
                    }
                }
            }
        }
        
        if (self.skyLightSend) {
            for (int j = 0; j<[chunkColumn.chunks count]; j++) {
                Chunk *chunk = (Chunk *)[chunkColumn.chunks objectAtIndex:j];
                if (!chunk.isEmpty) {
                    for (int y = 0; y<[chunkColumn.chunks count]; y++) {
                        for (int z = 0; z<[chunkColumn.chunks count]; z++) {
                            for (int x = 0; x<[chunkColumn.chunks count]; x+=2) {
                                Nibbler nibb;
                                nibb.nibbles.first = [[chunk blockAtX:x Y:y Z:z] tcpSkyLight];
                                nibb.nibbles.second = [[chunk blockAtX:x+1 Y:y Z:z] tcpSkyLight];
                                [chunkColumnsDataZipped appendNibbler:nibb];
                            }
                        }
                    }
                }
            }
        }
        
        //nothing to add
        /*for (int j = 0; j<16; j++) {
            Chunk *chunk = (Chunk *)[chunkColumn.chunks objectAtIndex:j];
            if (!chunk.isEmpty) {
                for (int y = 0; y<16; y++) {
                    for (int z = 0; z<16; z++) {
                        for (int x = 0; x<16; x+=2) {
                            Nibbler nibb;
                            nibb.nibbles.first = [[chunk blockAtX:x Y:y Z:z] tcpBlockAdd];
                            nibb.nibbles.second = [[chunk blockAtX:x+1 Y:y Z:z] tcpBlockAdd];
                            [chunkColumnsDataZipped appendNibbler:nibb];
                        }
                    }
                }
            }
        }*/
        
        //TO-DO: Implement Biomes
        for (int j = 0; j<[chunkColumn.chunks count]; j++) {
            Chunk *chunk = (Chunk *)[chunkColumn.chunks objectAtIndex:j];
            if (!chunk.isEmpty) {
                for (int z = 0; z<[chunkColumn.chunks count]; z++) {
                    for (int x = 0; x<[chunkColumn.chunks count]; x+=4) {
                        BitArray bits;
                        bits.bits.bit1 = 0;
                        bits.bits.bit2 = 0;
                        bits.bits.bit3 = 0;
                        bits.bits.bit4 = 0;
                        [chunkColumnsDataZipped appendBitArray:bits];
                    }
                }
            }
        }
        
#ifdef TEST
        [chunkColumnsDataZipped appendInt:9];//chunk biome data end
#endif
        
    }
    
    OFDataArray *zippedChunkColumnData = [chunkColumnsDataZipped zlibDeflate];
    [packetData appendInt:(int32_t)[zippedChunkColumnData count]];
    [packetData appendBoolTcp:self.skyLightSend];
    [packetData addItems:[zippedChunkColumnData firstItem] count:[zippedChunkColumnData count]];
    [packetData addItems:[chunkColumnsData firstItem] count:[chunkColumnsData count]];
    return packetData;
}

@end
