//
//  TCPServerPacket.m
//  MinecraftServer
//
//  Created by Victor Brekenfeld on 03.02.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "TCPServerPacket.h"
#import "OFDataArray+VarIntWriter.h"

static OFArray *packetListServer;

@implementation TCPServerPacket

+ (void)setup {
    if (self != [TCPServerPacket class]) {
        
        if (!packetListServer)
            packetListServer = [[OFArray alloc] initWithObjects:[[OFMutableDictionary alloc] init], [[OFMutableDictionary alloc] init], [[OFMutableDictionary alloc] init], [[OFMutableDictionary alloc] init], nil];
        
        @try {
            [TCPServerPacket addPacketClass:self withState:[self state] forId:[self packetId]];
        }
        @catch (OFException *exception) {}
        
    }
}

+ (void)addPacketClass:(Class)class withState:(int)state forId:(uint8_t)pId {
    if ([class isSubclassOfClass:[TCPServerPacket class]])
        [[packetListServer objectAtIndex:state] setObject:[class description] forKey:[OFString stringWithFormat:(OFConstantString *)@"%02x", pId]];
}

- (OFDataArray *)packetData {
    @throw [OFException exception]; //WithName:@"Raw TCPPacket call" reason:[NSString stringWithFormat:@"PacketData must be overriden and called via subclass %@", [self class]] userInfo:nil];
}


- (OFDataArray *)rawPacketData {
    OFDataArray *packetData = [self packetData];
    uint64_t packetId = [[self class] packetId];
    [packetData prependVarInt:packetId];
    [packetData prependVarInt:[packetData count]];
    return packetData;
}

+ (TCPServerPacket *)clientPacketWithState:(int)state ID:(uint64_t)pId data:(OFDataArray *)data {
    @try {
        return (TCPServerPacket *)[[objc_getClass([[[packetListServer objectAtIndex:state] objectForKey:[OFString stringWithFormat:(OFConstantString *)@"%02x", pId]] UTF8String]) alloc] initWithData:data];
    }
    @catch (OFException *exception) {
        return nil;
    }
}

- (instancetype)initWithData:(OFDataArray *)data {
    return [super init];
}

+ (int)state {
    return 3; //most packets belong to the 'Play' state
}

+ (uint64_t)packetId {
    @throw [OFException exception]; //WithName:@"Raw TCPPacket call" reason:[NSString stringWithFormat:@"PacketID must be overriden and called via subclass %@", [self class]] userInfo:nil];
}

@end
