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
@synthesize clientId, sessionId, unknown;

- (instancetype)initWithData:(OFDataArray *)data {
    self = [super init];
    @try {
        self.clientId = [data readLong];
        self.sessionId = [data readLong];
        self.unknown = [data readByte];
    } @catch (id e) {
        [self release];
        @throw e;
    }
    return self;
}

+ (uint8_t)packetId {
    return 0x09;
}

- (OFDataArray *)packetData {
    OFDataArray *packetData = [OFDataArray dataArray];
    [packetData appendLong:self.clientId];
    [packetData appendLong:self.sessionId];
    [packetData appendByte:self.unknown];
    return packetData;
}

@end
