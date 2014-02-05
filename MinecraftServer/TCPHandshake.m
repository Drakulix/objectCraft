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

- (instancetype)initWithData:(OFDataArray *)data {
    self = [super init];
    if (self) {
        _protocolVersion = [data readVarInt];
        _serverAddress = [data readStringTcp];
        _serverPort = [data readShort];
        _nextState = [data readVarInt];
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
