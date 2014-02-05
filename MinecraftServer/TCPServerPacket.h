//
//  TCPServerPacket.h
//  MinecraftServer
//
//  Created by Victor Brekenfeld on 03.02.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "TCPPacket.h"

@interface TCPServerPacket : TCPPacket

- (OFDataArray *)packetData;
- (OFDataArray *)rawPacketData;

@end
