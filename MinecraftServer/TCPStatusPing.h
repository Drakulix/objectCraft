//
//  TCPStatusPing.h
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 10.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "TCPClientPacket.h"

@interface TCPStatusPing : TCPClientPacket

@property (readonly) int64_t time;

@end
