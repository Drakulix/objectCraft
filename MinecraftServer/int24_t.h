//
//  int24_t.h
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 14.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import <stdint.h>

typedef union {
    uint32_t i;
    uint8_t bytes[4];
} uint24_t;

typedef union {
    int32_t i;
    uint8_t bytes[4];
} int24_t;