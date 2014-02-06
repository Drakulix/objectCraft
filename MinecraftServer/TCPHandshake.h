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

@property (nonatomic) uint64_t protocolVersion;
@property (nonatomic, retain) OFString *serverAddress;
@property (nonatomic) uint16_t serverPort;
@property (nonatomic) uint64_t nextState;

@end
