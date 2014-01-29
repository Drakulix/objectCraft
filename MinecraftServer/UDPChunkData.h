//
//  UDPChunkData.h
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 20.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "UDPPacket.h"
#import "ChunkColumn.h"

@interface UDPChunkData : UDPPacket

@property ChunkColumn *column;

- (instancetype)initForChunkColumn:(ChunkColumn *)column;

@end
