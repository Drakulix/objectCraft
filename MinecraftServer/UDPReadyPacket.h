//
//  UDPReadyPacket.h
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 20.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "UDPPacket.h"

@interface UDPReadyPacket : UDPPacket

@property int8_t status;

- (instancetype)initWithStatus:(int8_t)status;

@end
