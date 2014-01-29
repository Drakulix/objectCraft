//
//  WorldManager.m
//  MinecraftServer
//
//  Created by Victor Brekenfeld on 26.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "log.h"
#import "WorldManager.h"
#import "ConfigManager.h"
#import "World.h"
#import "WorldGenerator.h"

@implementation WorldManager

static WorldManager *sharedInstance;

+ (WorldManager *)defaultManager {
    if (!sharedInstance) {
        sharedInstance = [[self alloc] init];
    }
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        dimensions = [[OFMutableDictionary alloc] init];
        OFDictionary *configuration = [ConfigManager defaultManager].dimensions;
        OFArray *keys = [configuration allKeys];
        for (int i = 0; i < [keys count]; i++) {
            World *world = [[World alloc] initWithGenerator:[configuration objectForKey:[keys objectAtIndex:i]] forDimension:(int8_t)[[keys objectAtIndex:i] int8Value]];
            [dimensions setObject:world forKey:[keys objectAtIndex:i]];
        }
    }
    return self;
}

- (void)dealloc {
    OFArray *keys = [dimensions allKeys];
    for (int i = 0; i < [dimensions count]; i++) {
        [[dimensions objectForKey:[keys objectAtIndex:i]] saveWorld];
    }
    [super dealloc];
}

@end
