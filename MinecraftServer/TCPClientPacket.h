//
//  TCPClientPacket.h
//  MinecraftServer
//
//  Created by Victor Brekenfeld on 03.02.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "TCPPacket.h"

@interface TCPClientPacket : TCPPacket

+ (void)setup;
+ (TCPClientPacket *)clientPacketWithState:(int)state ID:(uint64_t)pID data:(OFDataArray *)data;
- (instancetype)initWithData:(OFDataArray *)data;

@end
