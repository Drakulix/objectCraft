//
//  TCPClientPacket.m
//  MinecraftServer
//
//  Created by Victor Brekenfeld on 03.02.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "log.h"
#import "TCPClientPacket.h"

static OFArray *packetListClient;

@implementation TCPClientPacket

+ (void)setup {
    if (self != [TCPClientPacket class]) {
        
        if (!packetListClient)
            packetListClient = [[OFArray alloc] initWithObjects:[[OFMutableDictionary alloc] init], [[OFMutableDictionary alloc] init], [[OFMutableDictionary alloc] init], [[OFMutableDictionary alloc] init], nil];
        
        @try {
            [TCPClientPacket addPacketClass:self withState:[self state] forId:[self packetId]];
        }
        @catch (OFException *exception) {}
        
    }
}

+ (void)addPacketClass:(Class)class withState:(int)state forId:(uint8_t)pId {
    if ([class isSubclassOfClass:[TCPClientPacket class]]) {
        @autoreleasepool {
            [[packetListClient objectAtIndex:state] setObject:[class description] forKey:[OFString stringWithFormat:(OFConstantString *)@"%02x", pId]];
        }
    }
}

+ (TCPClientPacket *)clientPacketWithState:(int)state ID:(uint64_t)pId data:(OFDataArray *)data {
    @try {
        return [(TCPClientPacket *)[[objc_getClass([[[packetListClient objectAtIndex:state] objectForKey:[OFString stringWithFormat:(OFConstantString *)@"%02x", pId]] UTF8String]) alloc] initWithData:data] autorelease];
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
    @throw [OFNotImplementedException exception]; //WithName:@"Raw TCPPacket call" reason:[NSString stringWithFormat:@"PacketID must be overriden and called via subclass %@", [self class]] userInfo:nil];
}

- (OFDataArray *)packetData {
    @throw [OFNotImplementedException exception]; //WithName:@"Raw TCPPacket call" reason:[NSString stringWithFormat:@"PacketData must be overriden and called via subclass %@", [self class]] userInfo:nil];
}

@end
