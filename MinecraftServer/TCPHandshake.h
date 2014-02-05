//
//  TCPPacketHandshake.h
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 05.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import <ObjFW/ObjFW.h>
#import "TCPClientPacket.h"

@interface TCPHandshake : TCPClientPacket

@property (readonly) uint64_t protocolVersion;
@property (readonly, retain) OFString *serverAddress;
@property (readonly) uint16_t serverPort;
@property (readonly) uint64_t nextState;

@end
