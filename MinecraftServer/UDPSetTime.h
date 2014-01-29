//
//  UDPSetTime.h
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 17.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "UDPPacket.h"

@interface UDPSetTime : UDPPacket

@property int32_t time;

- (instancetype)initWithDaytime:(int32_t)time;

@end
