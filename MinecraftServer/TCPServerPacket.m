//
//  TCPServerPacket.m
//  MinecraftServer
//
//  Created by Victor Brekenfeld on 03.02.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "TCPServerPacket.h"
#import "OFDataArray+VarIntWriter.h"

@implementation TCPServerPacket

- (OFDataArray *)packetData {
    @throw [OFNotImplementedException exception]; //WithName:@"Raw TCPPacket call" reason:[NSString stringWithFormat:@"PacketData must be overriden and called via subclass %@", [self class]] userInfo:nil];
}

- (OFDataArray *)rawPacketData {
    OFDataArray *packetData = [[self packetData] retain];
    
    uint64_t packetId = [[self class] packetId];
    [packetData prependVarInt:packetId];
    [packetData prependVarInt:[packetData count]];
    
    return [packetData autorelease];
}

+ (int)state {
    return 3; //most packets belong to the 'Play' state
}

+ (uint64_t)packetId {
    @throw [OFNotImplementedException exception]; //WithName:@"Raw TCPPacket call" reason:[NSString stringWithFormat:@"PacketID must be overriden and called via subclass %@", [self class]] userInfo:nil];
}

@end
