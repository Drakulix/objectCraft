//
//  TCPPacketHandler.m
//  MinecraftServer
//
//  Created by Victor Brekenfeld on 03.02.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "log.h"
#import "TCPPacketHandler.h"
#import "OFDataArray+VarIntReader.h"
#import "TCPClientPacket.h"

@implementation TCPPacketHandler

-(instancetype)initWithDelegate:(id<TCPPacketDelegate>)delegate {
    self = [super init];
    if (self) {
        self.delegate = delegate;
    }
    return self;
}

- (void)recievedPacket:(OFDataArray *)data {
    uint64_t packetId = [data readVarInt];
    LogDebug(@"Got Packet with ID: %02x", packetId);
    
    [self.delegate recievedPacket:[TCPClientPacket clientPacketWithState:[self.delegate state] ID:packetId data:data]];
}

@end
