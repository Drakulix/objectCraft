//
//  World.h
//  MinecraftServer
//
//  Created by Victor Brekenfeld on 27.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import <ObjFW/ObjFW.h>
@class WorldGenerator;

@interface World : OFObject {
    WorldGenerator *generator;
    int8_t dimension;
}

- (instancetype)initWithGenerator:(OFString *)generator forDimension:(int8_t)dimension;
- (void)saveWorld;

@end
