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

- (id)init {
    if (!sharedInstance)
        sharedInstance = [[AirBlock alloc] initSilent];
    return sharedInstance;
}

- (instancetype)initSilent {
    return [super init];
}

- (uint8_t)tcpSkyLight {
    return 15;
}

@end
