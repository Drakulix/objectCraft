//
//  RaknetCustomPacket.m
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 09.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "RaknetCustomPacket.h"
#import "UDPClientConnection.h"

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
        self.packets = [[NSMutableArray alloc] init];
    }
    return self;
}

- (instancetype)initWithData:(NSData *)data {
    self = [super init];
    if (self) {
        self.packets = [[NSMutableArray alloc] init];
        NSMutableData *packetData = [data mutableCopy];
        
        packetNumber = [packetData readReverseUInt24];
        
        while ([packetData length] > 0) {
            [self.packets addObject:[RaknetMinecraftPacket readPacketFromData:packetData]];
        }
    }
    return self;
}

+ (uint8_t)packetId {
    return 0x80;
}

- (void)dispatchNewTransmissionVia:(UDPClientConnection *)handler {
    __block UDPClientConnection *blockHandler = handler;
    __block RaknetCustomPacket *packet = self;
    double delayInSeconds = 3.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        @synchronized (blockHandler.queuedPackets) {
            if (![blockHandler.queuedPackets objectForKey:@(packetNumber.i)]) {
                NSLogDebug(@"Packet lost: %@", packet);
                [blockHandler sendRaknetPacket:packet];
                [self dispatchNewTransmissionVia:handler];
            }
        }
    });
}

- (NSData *)packetData {
    NSMutableData *data = [[NSMutableData alloc] init];
    [data appendReverseUInt24:packetNumber];
    
    for (RaknetMinecraftPacket *packet in self.packets) {
        [data appendData:[packet packetData]];
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

@end
