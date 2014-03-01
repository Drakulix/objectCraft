//
//  RaknetCustomPacket.m
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 09.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "log.h"
#import "RaknetCustomPacket.h"
#import "UDPClientConnection.h"
#import "OFDataArray+IntReader.h"
#import "OFDataArray+IntWriter.m"
#import <dispatch/dispatch.h>

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
    @try {
        self.packets = [[OFMutableArray alloc] init];
    } @catch (id e) {
        [self release];
        @throw e;
    }
    return self;
}

- (instancetype)initWithData:(OFDataArray *)data {
    self = [super init];
    @try {
        self.packets = [[[OFMutableArray alloc] init] autorelease];
        
        packetNumber = [data readReverseUInt24];
        
        @try {
            while ([data count] > 0) {
                [self.packets addObject:[RaknetMinecraftPacket readPacketFromData:data]];
            }
        }
        @catch (OFException *exception) {
            return nil;
        }
    } @catch (id e) {
        [self release];
        @throw e;
    }
    return self;
}

- (void)dealloc {
    //do not release the timer here,
    //it will get released on the next fire
    [self.packets release];
    [super dealloc];
}

+ (uint8_t)packetId {
    return 0x80;
}

- (OFDataArray *)packetData {
    OFDataArray *data = [OFDataArray dataArray];
    [data appendReverseUInt24:packetNumber];
    
    for (RaknetMinecraftPacket *packet in self.packets) {
        OFDataArray *packetData = [packet packetData];
        [data addItems:[packetData items] count:[packetData count]];
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
    double delayInSeconds = 3.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self resend];
    });
}

- (void)resend {
    if (![handler wasPacketAckd:packetNumber.i]) {
        LogDebug(@"Packet lost: %@", self);
        [handler sendRaknetPacket:self];
    }
}


@end
