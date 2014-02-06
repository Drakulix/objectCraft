//
//  TCPPlayerAbilities.m
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 06.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "TCPPlayerAbilities.h"
#import "OFDataArray+IntWriter.h"
#import "OFDataArray+FloatWriter.h"

@implementation TCPPlayerAbilities

- (instancetype)initWithPlayer:(Player *)player {
    self = [super init];
    @try {
        self.canBeDamaged = player.canBeDamaged;
        self.canFly = player.canFly;
        self.isFlying = player.canFly;
        self.isCreativeMode = player.isCreativeMode;
        
        self.walkingSpeed = player.walkingSpeed;
        self.flyingSpeed = player.flyingSpeed;
    } @catch (id e) {
        [self release];
        @throw e;
    }
    return self;
}

+ (uint64_t)packetId {
    return 0x39;
}

- (OFDataArray *)packetData {
    OFDataArray *packetData = [OFDataArray array];
    int8_t flags = 0;
    if (self.canBeDamaged)
        flags |= 1 << 0;
    if (self.canFly)
        flags |= 1 << 1;
    if (self.isFlying)
        flags |= 1 << 2;
    if (self.isCreativeMode)
        flags |= 1 << 3;
    [packetData appendByte:flags];
    [packetData appendFloat:self.walkingSpeed];
    [packetData appendFloat:self.flyingSpeed];
    return packetData;
}

@end
