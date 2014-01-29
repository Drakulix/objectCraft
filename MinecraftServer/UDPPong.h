//
//  UDPPong.h
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 10.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "UDPPacket.h"

@interface UDPPong : UDPPacket

@property (nonatomic) uint64_t clientTime;
@property (nonatomic) uint64_t serverTime;

- (instancetype)initWithClientTime:(int64_t)clientTime;

@end
