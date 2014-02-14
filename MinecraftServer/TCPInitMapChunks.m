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

@implementation TCPInitMapChunks

- (instancetype)initForTcpDimension:(int8_t)dimension {
    self = [super init];
    @try {
        self.skyLightSend = (dimension == 0);
        chunkColumns = [[OFMutableArray alloc] init];
    } @catch (id e) {
        [self release];
        @throw e;
    }
    return self;
}

- (void)dealloc {
    [chunkColumns release];
    [super dealloc];
}

- (void)addChunkColumn:(ChunkColumn *)chunk {
    [chunkColumns addObject:chunk];
}

+ (uint64_t)packetId {
    return 0x26;
}

- (OFDataArray *)packetData {
    
    OFDataArray *packetData = [[OFDataArray alloc] init];
    
    @autoreleasepool {
        [packetData appendShort:[chunkColumns count]];
        
        OFDataArray *chunkColumnsData = [[OFDataArray alloc] init];
        OFDataArray *chunkColumnsCompressedData = [[OFDataArray alloc] init];
        
        int chunkCounter = 0;
        
        for (int i = 0; i<[chunkColumns count]; i++) {
            
            ChunkColumn *chunkColumn = [chunkColumns objectAtIndex:i];
            
            [chunkColumnsData appendInt:chunkColumn.X];
            [chunkColumnsData appendInt:chunkColumn.Z];
            
            int16_t primaryBitMask = 0;
            for (int j = 0; j<[chunkColumn chunkCount]; j++) {
                if (!((Chunk *)[chunkColumn chunkAtIndex:j]).isEmpty) {
                    primaryBitMask |= 1 << j;
                }
            }
            
            int16_t addBitMask = 0;
            //currently no block "adds" stuff (id's over 128)
            /*for (int j = 0; j<16; j++) {
                if (Chunk contains block with id over 128)
                    addBitMask |= 1 << j;
            }*/
            [chunkColumnsData appendShort:primaryBitMask];
            [chunkColumnsData appendShort:addBitMask];
            
            for (int j = 0; j<[chunkColumn chunkCount]; j++) {
                Chunk *chunk = (Chunk *)[chunkColumn chunkAtIndex:j];
                if (!chunk.isEmpty) {
                    chunkCounter++;
                    for (int y = 0; y<16; y++) {
                        for (int z = 0; z<16; z++) {
                            for (int x = 0; x<16; x++) {
                                [chunkColumnsCompressedData appendUnsignedByte:[[chunk blockAtX:x Y:y Z:z] tcpBlockId]];
                            }
                        }
                    }
                }
            }
            
            for (int j = 0; j<[chunkColumn chunkCount]; j++) {
                Chunk *chunk = (Chunk *)[chunkColumn chunkAtIndex:j];
                if (!chunk.isEmpty) {
                    for (int y = 0; y<16; y++) {
                        for (int z = 0; z<16; z++) {
                            for (int x = 0; x<16; x+=2) {
                                Nibbler nibb;
                                nibb.nibbles.first = [[chunk blockAtX:x Y:y Z:z] tcpMetadata];
                                nibb.nibbles.second = [[chunk blockAtX:x+1 Y:y Z:z] tcpMetadata];
                                [chunkColumnsCompressedData appendNibbler:nibb];
                            }
                        }
                    }
                }
            }
            
            for (int j = 0; j<[chunkColumn chunkCount]; j++) {
                Chunk *chunk = (Chunk *)[chunkColumn chunkAtIndex:j];
                if (!chunk.isEmpty) {
                    for (int y = 0; y<16; y++) {
                        for (int z = 0; z<16; z++) {
                            for (int x = 0; x<16; x+=2) {
                                Nibbler nibb;
                                nibb.nibbles.first = [[chunk blockAtX:x Y:y Z:z] tcpLightEmit];
                                nibb.nibbles.second = [[chunk blockAtX:x+1 Y:y Z:z] tcpLightEmit];
                                [chunkColumnsCompressedData appendNibbler:nibb];
                            }
                        }
                    }
                }
            }
            
            if (self.skyLightSend) {
                for (int j = 0; j<[chunkColumn chunkCount]; j++) {
                    Chunk *chunk = (Chunk *)[chunkColumn chunkAtIndex:j];
                    if (!chunk.isEmpty) {
                        for (int y = 0; y<16; y++) {
                            for (int z = 0; z<16; z++) {
                                for (int x = 0; x<16; x+=2) {
                                    Nibbler nibb;
                                    nibb.nibbles.first = [[chunk blockAtX:x Y:y Z:z] tcpSkyLight];
                                    nibb.nibbles.second = [[chunk blockAtX:x+1 Y:y Z:z] tcpSkyLight];
                                    [chunkColumnsCompressedData appendNibbler:nibb];
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
                                 [chunkColumnsCompressedData appendNibbler:nibb];
                             }
                         }
                     }
                 }
             }*/
            
            //TO-DO: Implement Biomes
            for (int j = 0; j<[chunkColumn chunkCount]; j++) {
                Chunk *chunk = (Chunk *)[chunkColumn chunkAtIndex:j];
                if (!chunk.isEmpty) {
                    for (int z = 0; z<16; z++) {
                        for (int x = 0; x<16; x+=4) {
                            BitArray bits;
                            bits.bits.bit1 = 0;
                            bits.bits.bit2 = 0;
                            bits.bits.bit3 = 0;
                            bits.bits.bit4 = 0;
                            [chunkColumnsCompressedData appendBitArray:bits];
                        }
                    }
                }
            }
            
        }
        
        OFDataArray *zippedChunkColumnData = [chunkColumnsCompressedData zlibDeflate];
        [packetData appendInt:(int32_t)[zippedChunkColumnData count]];
        [packetData appendBoolTcp:self.skyLightSend];
        [packetData addItems:[zippedChunkColumnData items] count:[zippedChunkColumnData count]];
        [packetData addItems:[chunkColumnsData items] count:[chunkColumnsData count]];
    }
    
    return [packetData autorelease];
}

@end
