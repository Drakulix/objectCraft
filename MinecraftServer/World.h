//
//  World.h
//  MinecraftServer
//
//  Created by Victor Brekenfeld on 27.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import <ObjFW/ObjFW.h>
@class WorldGenerator;
@class EntityManager;
@class ChunkManager;

@interface World : OFObject {
    WorldGenerator *generator;
}

@property (atomic) uint64_t ageInTicks;
@property (nonatomic) int8_t dimension;
@property (nonatomic) int8_t tcpDimension;
@property (nonatomic, retain) EntityManager *entityManager;
@property (nonatomic, retain) ChunkManager *chunkManager;

- (instancetype)initWithGenerator:(OFString *)generator forDimension:(int8_t)dimension;
- (void)tick;
- (void)saveWorld;

@end
