//
//  UDPClientConnect.m
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 09.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "UDPClientConnect.h"
#import "OFDataArray+IntReader.h"
#import "OFDataArray+IntWriter.h"

@implementation UDPClientConnect

- (instancetype)initWithData:(OFDataArray *)data {
    self = [super init];
    if (self) {
        self.clientId = [data readLong];
        self.sessionId = [data readLong];
        self.unknown = [data readByte];
    }
    return self;
}

+ (uint8_t)packetId {
    return 0x09;
}

- (OFDataArray *)packetData {
    OFDataArray *packetData = [[OFDataArray alloc] init];
    [packetData appendLong:self.clientId];
    [packetData appendLong:self.sessionId];
    [packetData appendByte:self.unknown];
    return packetData;
}

@end
