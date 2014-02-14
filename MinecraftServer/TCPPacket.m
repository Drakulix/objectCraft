//
//  TCPPacket.m
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 05.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "TCPPacket.h"
#import "TCPClientPacket.h"
#import "TCPServerPacket.h"

@implementation TCPPacket

- (instancetype)initWithData:(OFDataArray *)data {
    return [super init];
}

+ (int)state {
    return 3; //most packets belong to the 'Play' state
}

+ (uint64_t)packetId {
    @throw [OFNotImplementedException exception]; //WithName:@"Raw TCPPacket call" reason:[NSString stringWithFormat:@"PacketID must be overriden and called via subclass %@", [self class]] userInfo:nil];
}

@end
