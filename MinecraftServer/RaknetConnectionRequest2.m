//
//  RaknetConnectionRequest2.m
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 09.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "RaknetConnectionRequest2.h"
#import "OFDataArray+IntReader.h"
#import "OFDataArray+IntWriter.h"
#import "OFDataArray+RaknetMagic.h"

@implementation RaknetConnectionRequest2

- (instancetype)initWithData:(OFDataArray *)data {
    self = [super init];
    if (self) {
        if (![data checkMagic])
            return nil;
        self.clientSecurity = [data readByte];
        self.cookie = [data readInt];
        self.serverUDPPort = [data readShort];
        self.mtuSize = [data readShort];
        self.clientId = [data readLong];
    }
    return self;
}

+ (uint8_t)packetId {
    return 0x07;
}

- (OFDataArray *)packetData {
    OFDataArray *packetData = [[OFDataArray alloc] init];
    [packetData appendMagic];
    [packetData appendByte:self.clientSecurity];
    [packetData appendInt:self.cookie];
    [packetData appendShort:self.serverUDPPort];
    [packetData appendShort:self.mtuSize];
    [packetData appendLong:self.clientId];
    return packetData;
}

@end
