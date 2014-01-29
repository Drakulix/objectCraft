//
//  UDPLoginStatus.h
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 10.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "UDPPacket.h"

@interface UDPLoginStatus : UDPPacket

@property int32_t status;

- (instancetype)initWithStatus:(int32_t)status;

@end
