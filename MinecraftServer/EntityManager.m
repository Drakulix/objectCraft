//
//  EntityManager.m
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 06.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "EntityManager.h"
#import "World.h"

@implementation EntityManager

- (instancetype)initWithWorld:(World *)_world {
    self = [super init];
    @try {
        entityList = [[OFMutableArray alloc] init];
        world = [_world retain];
    } @catch (id e) {
        [self release];
        @throw e;
    }
    return self;
}

- (void)dealloc {
    [world release];
    [entityList release];
    [super dealloc];
}

- (Entity *)addEntityOfClass:(Class)class {
    @synchronized (entityList) {
        Entity *entity = [[class alloc] init];
        
        size_t firstNullIndex = [entityList indexOfObjectIdenticalTo:[OFNull null]];
        if (firstNullIndex != OF_NOT_FOUND) {
            entity.entityId = firstNullIndex;
            [entityList replaceObjectAtIndex:firstNullIndex withObject:entity];
        } else {
            entity.entityId = [entityList count];
            [entityList addObject:entity];
        }
        [entity release];
        
        entity.dimension = world.dimension;
        entity.tcpDimension = world.tcpDimension;
        
        return entity;
    }
}

- (void)removeEntity:(Entity *)entity {
    @synchronized (entityList) {
        [entityList replaceObjectAtIndex:[entityList indexOfObjectIdenticalTo:entity] withObject:[OFNull null]];
    }
}


- (void)removeEntityById:(int32_t)entityId {
    @synchronized (entityList) {
        [entityList replaceObjectAtIndex:entityId withObject:[OFNull null]];
    }
}

@end
