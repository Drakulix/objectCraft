//
//  TCPClientConnection.h
//  MinecraftServer
//
//  Created by Victor Brekenfeld on 03.02.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import <ObjFW/ObjFW.h>
#import "TCPPacketHandler.h"
@class TCPServerPacket;

@interface TCPClientConnection : OFObject {
    OFTCPSocket *socket;
    TCPPacketHandler *packetHandler;
}

- (instancetype)initWithSocket:(OFTCPSocket *)socket;
- (void)disconnectClient;
- (void)changeDelegate:(id<TCPPacketDelegate>)delegate;
- (void)sendPacket:(TCPServerPacket *)packet;

@end
