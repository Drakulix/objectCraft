//
//  TCPTimeUpdate.h
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 07.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "TCPServerPacket.h"

@interface TCPTimeUpdate : TCPServerPacket

@property (nonatomic) int64_t ageOfWorld;
@property (nonatomic) int64_t timeOfDay;

- (instancetype)initWithAge:(int64_t)age andDayTime:(int64_t)time;

@end
