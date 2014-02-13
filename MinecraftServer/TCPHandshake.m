//
//  TCPPacketHandshake.m
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 05.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "TCPHandshake.h"
#import "OFDataArray+VarIntReader.h"
#import "OFDataArray+IntReader.h"
#import "OFDataArray+StringReader.h"

@implementation TCPHandshake
@synthesize protocolVersion, serverAddress, serverPort, nextState;

- (instancetype)initWithData:(OFDataArray *)data {
    self = [super init];
    @try {
        self.protocolVersion = [data readVarInt];
        self.serverAddress = [data readStringTcp];
        self.serverPort = [data readShort];
        self.nextState = [data readVarInt];
    } @catch (id e) {
        [self release];
        @throw e;
    }
    return self;
}

+ (int)state {
    return 0;
}

+ (uint64_t)packetId {
    return 0x00;
}

@end
