//
//  ChunkColumn.h
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 06.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import <ObjFW/ObjFW.h>
@class Chunk;

@interface ChunkColumn : OFObject

@property (retain) OFMutableArray *chunks;
@property int32_t X;
@property int32_t Z;

@end
