//
//  RaknetIncompatibleProtocol.m
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 09.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "RaknetIncompatibleProtocol.h"
#import "ConfigManager.h"
#import "OFDataArray+IntReader.h"
#import "OFDataArray+IntWriter.h"
#import "OFDataArray+RaknetMagic.h"

@implementation RaknetIncompatibleProtocol

- (id)init {
    self = [super init];
    if (self) {
        self.protocolVersion = 5;
        self.serverId = [ConfigManager defaultManager].udpServerId;
    }
    return self;
}

- (id)initWithData:(OFDataArray *)data {
    self = [super init];
    if (self) {
        self.protocolVersion = [data readByte];
        if (![data checkMagic]) {
            return nil;
        }
        self.serverId = [data readLong];
    }
    return self;
}

+ (uint8_t)packetId {
    return 0x1a;
}

- (OFDataArray *)packetData {
    OFDataArray *packetData = [[OFDataArray alloc] init];
    
    [packetData appendByte:self.protocolVersion];
    [packetData appendMagic];
    [packetData appendLong:self.serverId];
    
    return packetData;
}

@end
