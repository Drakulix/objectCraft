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
@synthesize delegate;

-(instancetype)initWithDelegate:(id<TCPPacketDelegate>)_delegate {
    self = [super init];
    @try {
        self.delegate = _delegate;
    } @catch (id e) {
        [self release];
        @throw e;
    }
    return self;
}

- (void)recievedPacket:(OFDataArray *)data {
    uint64_t packetId = [data readVarInt];
    LogDebug(@"Got Packet with ID: %02x", packetId);
    
    @autoreleasepool {
        [self.delegate recievedPacket:[TCPClientPacket clientPacketWithState:[self.delegate state] ID:packetId data:data]];
    }
}

@end
