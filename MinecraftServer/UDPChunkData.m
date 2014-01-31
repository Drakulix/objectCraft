//
//  UDPChunkData.m
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 20.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "UDPChunkData.h"
#import "Chunk.h"
#import "ChunkColumn.h"
#import "Block.h"
#import "OFDataArray+IntWriter.h"

@implementation UDPChunkData

- (instancetype)initForChunkColumn:(ChunkColumn *)column andBitMask:(uint8_t)bitmask {
    self = [super init];
    if (self) {
        self.column = column;
        self.bitMask = bitmask;
    }
    return self;
}

- (instancetype)initWithData:(OFDataArray *)data {
    self = [super init];
    if (self) {
        //no reading right now
    }
    return self;
}

+ (uint8_t)packetId {
    return 0x9f;
}

- (OFDataArray *)packetData {
    OFDataArray *packetData = [[OFDataArray alloc] init];
    
    [packetData appendInt:self.column.X];
    [packetData appendInt:self.column.Z];
    
    for (int y = 0; y<16; y++) {
        for (int z = 0; z<16; z++) {
            
            [packetData appendByte:self.bitMask];
            
            for (int yColumn = 0; yColumn < 8; yColumn++) {
                
                if (self.bitMask == 0xff) {
                    
                    Chunk *chunk = [self.column.chunks objectAtIndex:yColumn];
                    
                    //block ids
                    for (int x = 0; x<16; x++) {
                        [packetData appendByte:[[chunk blockAtX:x Y:y Z:z] udpBlockId]];
                    }
                    //metadata
                    for (int x = 0; x<16; x+=2) {
                        Nibbler nibb;
                        nibb.nibbles.first = [[chunk blockAtX:x Y:y Z:z] udpMetadata];
                        nibb.nibbles.second = [[chunk blockAtX:x+1 Y:y Z:z] udpMetadata];
                        [packetData appendNibbler:nibb];
                    }
                    
                }
            }
        }
    }
    
    return packetData;
}

@end
