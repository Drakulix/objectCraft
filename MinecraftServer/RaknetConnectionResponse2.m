//
//  RaknetConnectionResponse2.m
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 09.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "RaknetConnectionResponse2.h"
#import "ConfigManager.h"
#import "OFDataArray+IntReader.h"
#import "OFDataArray+IntWriter.h"
#import "OFDataArray+RaknetMagic.h"

@implementation RaknetConnectionResponse2
@synthesize serverSecurity, mtuSize, clientUDPPort, serverId;

- (instancetype)initWithMtuSize:(int16_t)_mtuSize andClientPort:(int16_t)port {
    self = [super init];
    @try {
        self.serverId = [ConfigManager defaultManager].udpServerId;
        self.mtuSize = _mtuSize;
        self.clientUDPPort = port;
        self.serverSecurity = 0;
    } @catch (id e) {
        [self release];
        @throw e;
    }
    return self;
}

+ (uint8_t)packetId {
    return 0x08;
}

- (OFDataArray *)packetData {
    OFDataArray *packetData = [OFDataArray dataArray];
    [packetData appendMagic];
    [packetData appendLong:self.serverId];
    [packetData appendShort:self.clientUDPPort];
    [packetData appendShort:self.mtuSize];
    [packetData appendByte:self.serverSecurity];
    return packetData;
}

@end
