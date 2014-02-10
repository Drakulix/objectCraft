//
//  DirtBlock.m
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 06.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "DirtBlock.h"

@implementation DirtBlock

static DirtBlock *sharedInstance = nil;

+ (id)alloc {
    
    if (!sharedInstance) {
        sharedInstance = [super alloc];
    }
    return sharedInstance;
}

- (uint8_t)tcpBlockId {
    return 2;
}

- (uint8_t)tcpSkyLight {
    return 15;
}

- (uint8_t)udpBlockId {
    return 2;
}

@end
