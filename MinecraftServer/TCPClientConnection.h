//
//  TCPClientConnection.h
//  MinecraftServer
//
//  Created by Victor Brekenfeld on 03.02.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import <ObjFW/ObjFW.h>
#import "TCPPacketHandler.h"
#import "OFDataArray+VarIntReader.h"
@class TCPServerPacket;
@class MinecraftServer;

typedef bool (^PacketReadBlock)(OFStream*, void *, size_t, OFException*);

@interface TCPClientConnection : OFObject {
    OFTCPSocket *socket;
    TCPPacketHandler *packetHandler;
    MinecraftServer *server;
    
    VarIntBlock varIntReadCallback;
    PacketReadBlock packetReadCallback;
}

- (instancetype)initWithSocket:(OFTCPSocket *)socket fromMinecraftServer:(MinecraftServer *)server;
- (void)disconnectClient;
- (void)changeDelegate:(id<TCPPacketDelegate>)delegate;
- (void)sendPacket:(TCPServerPacket *)packet;

@end
