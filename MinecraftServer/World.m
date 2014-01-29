//
//  World.m
//  MinecraftServer
//
//  Created by Victor Brekenfeld on 27.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "log.h"
#import "World.h"
#import "ConfigManager.h"
#import "WorldGenerator.h"
#import <objc/runtime.h>

@implementation World

- (instancetype)initWithGenerator:(OFString *)_generator forDimension:(int8_t)_dimension {
    self = [super init];
    if (self) {
        dimension = _dimension;
        
        //TO-DO World based seeds (optional, use global seed if not set)
        
        if ([OFFile fileExistsAtPath:[OFString stringWithFormat:@"worlds/%d/world.conf", dimension]]) {
            OFFile *seedFile = [OFFile fileWithPath:[OFString stringWithFormat:@"worlds/%d/world.conf", dimension] mode:@"rb"];
            if ([seedFile readBigEndianInt64] != [ConfigManager defaultManager].seed ) {
                LogWarn(@"Global Seed has changed! World might get ugly chunk borders! Old world seed: %d, new seed: %d", [seedFile readBigEndianInt64], [ConfigManager defaultManager].seed);
                generator = (WorldGenerator *)[[(objc_getClass([_generator UTF8String])) alloc] initWithSeed:[[ConfigManager defaultManager] seed]];
            } else {
                generator = (WorldGenerator *)[[(objc_getClass([_generator UTF8String])) alloc] initWithSeed:[seedFile readBigEndianInt64]];
            }
            [seedFile close];
        } else {
            generator = (WorldGenerator *)[[(objc_getClass([_generator UTF8String])) alloc] initWithSeed:[ConfigManager defaultManager].seed];
        }
        
        //To-do load default spawn chunks
    }
    return self;
}

- (void)saveWorld {
    OFFile *seedFile = [OFFile fileWithPath:[OFString stringWithFormat:@"worlds/%d/world.conf", dimension] mode:@"wb"];
    [seedFile writeBigEndianInt64:[ConfigManager defaultManager].seed];
    [seedFile writeBigEndianInt64:[generator generatorState]];
    [seedFile close];
    
    //To-do save dirty chunks per file
}

@end
