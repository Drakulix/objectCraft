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
        [self start];
    }
    return self;
}

- (id)main {
    
    OFDictionary *configuration = [ConfigManager defaultManager].dimensions;
    OFArray *keys = [configuration allKeys];
    for (int i = 0; i < [keys count]; i++) {
        World *world = [[World alloc] initWithGenerator:[configuration objectForKey:[keys objectAtIndex:i]] forDimension:(int8_t)[[keys objectAtIndex:i] int8Value]];
        [dimensions setObject:world forKey:[keys objectAtIndex:i]];
    }
    
    OFArray *worlds = [dimensions allObjects];
    running = YES;
    
    while (running) {
        OFDate *date = [[OFDate date] dateByAddingTimeInterval:0.05];
        for (World *world in worlds) {
            [world tick];
        }
        if ([date timeIntervalSinceNow] > 0)
            [OFThread sleepUntilDate:date];
    }
    
    return nil;
}

- (void)shutdown {
    running = NO;
    for (World *world in [dimensions allObjects]) {
        [world saveWorld];
    }
    if ([OFThread currentThread] != self)
        [self join];
}

- (World *)worldForDimension:(int8_t)dimension {
    return [dimensions objectForKey:[OFNumber numberWithInt8:dimension]];
}

- (void)dealloc {
    OFArray *keys = [dimensions allKeys];
    for (int i = 0; i < [dimensions count]; i++) {
        [[dimensions objectForKey:[keys objectAtIndex:i]] shutdown];
    }
    [super dealloc];
}

@end
