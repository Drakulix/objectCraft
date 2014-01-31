//
//  Entity.m
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 06.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "Entity.h"
#import "MinecraftServer.h"

@implementation Entity

- (int32_t)blockPosX {
    return (int32_t)round(self.X);
}
- (int32_t)blockPosY {
    return (int32_t)round(self.Y);
}
- (int32_t)blockPosZ {
    return (int32_t)round(self.Z);
}

- (void)despawn {
    [[[MinecraftServer sharedInstance] worldForDimension:self.dimension] despawnEntityWithId:self.entityId];
}

@end
