//
//  EntityManager.h
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 06.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import <ObjFW/ObjFW.h>
#import "Entity.h"
@class World;

@interface EntityManager : OFObject {
    OFMutableArray *entityList;
    World *world;
}

- (instancetype)initWithWorld:(World *)world;

- (Entity *)addEntityOfClass:(Class)class;
- (void)removeEntity:(Entity *)entity;
- (void)removeEntityById:(int32_t)entityId;

@end
