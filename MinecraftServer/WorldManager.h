//
//  WorldManager.h
//  MinecraftServer
//
//  Created by Victor Brekenfeld on 26.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import <ObjFW/ObjFW.h>
@class World;

@interface WorldManager : OFObject {
    OFMutableDictionary *dimensions;
}

+ (WorldManager *)defaultManager;
- (World *)worldForDimension:(int8_t)dimension;

@end
