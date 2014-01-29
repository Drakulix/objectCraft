//
//  UDPSetHealth.h
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 20.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "UDPPacket.h"

@interface UDPSetHealth : UDPPacket

@property (nonatomic) int8_t health;

- (instancetype)initWithHealth:(int8_t)health;

@end
