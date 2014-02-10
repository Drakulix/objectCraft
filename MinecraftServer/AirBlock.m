//
//  AirBlock.m
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 06.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "AirBlock.h"

@implementation AirBlock

static AirBlock *sharedInstance = nil;

+ (id)alloc {
    
    if (!sharedInstance) {
        sharedInstance = [super alloc];
    }
    return sharedInstance;
}

- (uint8_t)tcpSkyLight {
    return 15;
}

@end
