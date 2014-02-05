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
#import "EntityManager.h"
#import "ChunkManager.h"
#import <objc/runtime.h>

@implementation World
@dynamic tcpDimension;
@synthesize dimension;

- (instancetype)initWithGenerator:(OFString *)_generator forDimension:(int8_t)_dimension {
    self = [super init];
    if (self) {
        dimension = _dimension;
        
        self.ageInTicks = 0; //TO-DO read current age from conf file
        
        //TO-DO World based seeds (optional, use global seed if not set)
        
        if ([OFFile fileExistsAtPath:[OFString stringWithFormat:(OFConstantString *)@"worlds/%d/world.conf", self.dimension]]) {
            OFFile *seedFile = [OFFile fileWithPath:[OFString stringWithFormat:(OFConstantString *)@"worlds/%d/world.conf", self.dimension] mode:@"rb"];
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
        
        self.chunkManager = [[ChunkManager alloc] initWithGenerator:generator];
        self.entityManager = [[EntityManager alloc] initWithWorld:self];
    }
    return self;
}

- (void)tick {
    self.ageInTicks++;
    //To-Do tick each loaded chunk. Chunk should update internal age value depending on if something has changed
    
    //IMPORTANT TO-DO handle ageInTicks overflow (best option is possibly to reset everything to 0 (all chunks, all player-counts)
}

- (int8_t)tcpDimension {
    return generator.tcpDimension;
}

- (void)saveWorld {
    OFFile *seedFile = [OFFile fileWithPath:[OFString stringWithFormat:(OFConstantString *)@"worlds/%d/world.conf", dimension] mode:@"wb"];
    [seedFile writeBigEndianInt64:[ConfigManager defaultManager].seed];
    [seedFile writeBigEndianInt64:[generator generatorState]];
    [seedFile close];
    //TO-DO write age to conf
    
    //To-do send save request to all loaded chunks
}

@end
