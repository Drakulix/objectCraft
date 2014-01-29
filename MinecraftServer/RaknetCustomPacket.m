//
//  RaknetCustomPacket.m
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 09.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "RaknetCustomPacket.h"
#import "UDPClientConnection.h"
#import "OFDataArray+IntReader.h"
#import "OFDataArray+IntWriter.m"

@implementation RaknetCustomPacket
@dynamic packetNumber;

+ (void)setup {
    [super setup];
    [RaknetPacket addPacketClass:self forId:0x80];
    [RaknetPacket addPacketClass:self forId:0x81];
    [RaknetPacket addPacketClass:self forId:0x82];
    [RaknetPacket addPacketClass:self forId:0x83];
    [RaknetPacket addPacketClass:self forId:0x84];
    [RaknetPacket addPacketClass:self forId:0x85];
    [RaknetPacket addPacketClass:self forId:0x86];
    [RaknetPacket addPacketClass:self forId:0x87];
    [RaknetPacket addPacketClass:self forId:0x88];
    [RaknetPacket addPacketClass:self forId:0x89];
    [RaknetPacket addPacketClass:self forId:0x8a];
    [RaknetPacket addPacketClass:self forId:0x8b];
    [RaknetPacket addPacketClass:self forId:0x8c];
    [RaknetPacket addPacketClass:self forId:0x8d];
    [RaknetPacket addPacketClass:self forId:0x8e];
    [RaknetPacket addPacketClass:self forId:0x8f];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.packets = [[OFMutableArray alloc] init];
    }
    return self;
}

- (instancetype)initWithData:(OFDataArray *)data {
    self = [super init];
    if (self) {
        self.packets = [[OFMutableArray alloc] init];
        
        packetNumber = [data readReverseUInt24];
        
        while ([data count] > 0) {
            [self.packets addObject:[RaknetMinecraftPacket readPacketFromData:data]];
        }
    }
    return self;
}

+ (uint8_t)packetId {
    return 0x80;
}

- (OFDataArray *)packetData {
    OFDataArray *data = [[OFDataArray alloc] init];
    [data appendReverseUInt24:packetNumber];
    
    for (RaknetMinecraftPacket *packet in self.packets) {
        OFDataArray *data = [packet packetData];
        [data addItems:[data firstItem] count:[data count]];
    }
    
    return data;
}

- (uint32_t)packetNumber {
    return packetNumber.i;
}

- (void)setPacketNumber:(uint32_t)_packetNumber {
    packetNumber.i = _packetNumber;
}

- (void)setPacketNumber24:(uint24_t)_packetNumber {
    packetNumber = _packetNumber;
}

- (void)dispatchNewTransmissionVia:(UDPClientConnection *)_handler {
    handler = _handler;
    timer = [OFTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(resend) repeats:NO];
}

- (void)resend {
    [timer invalidate];
    timer = nil;
    
    if (![handler wasPacketAckd:packetNumber.i]) {
        NSLogDebug(@"Packet lost: %@", packet);
        [handler sendRaknetPacket:packet];
    }
}


@end
