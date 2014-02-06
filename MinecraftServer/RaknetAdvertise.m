//
//  RaknetAdvertise.m
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 08.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "RaknetAdvertise.h"
#import "ConfigManager.h"
#import "OFDataArray+IntReader.h"
#import "OFDataArray+IntWriter.h"
#import "OFDataArray+StringReader.h"
#import "OFDataArray+StringWriter.h"
#import "OFDataArray+RaknetMagic.h"

@implementation RaknetAdvertise

- (instancetype)initWithPingId:(int64_t)pingId withIndetifier:(OFString *)string {
    self = [super init];
    @try {
        self.pingId = pingId;
        self.serverId = [ConfigManager defaultManager].udpServerId;
        self.identifier = string;
    } @catch (id e) {
        [self release];
        @throw e;
    }
    return self;
}

- (instancetype)initWithData:(OFDataArray *)data {
    self = [super init];
    @try {
        self.pingId = [data readLong];
        self.serverId = [data readLong];
        if(![data checkMagic]) {
            return nil;
        }
        self.identifier = [data readStringUdp];
    } @catch (id e) {
        [self release];
        @throw e;
    }
    return self;
}

+ (uint8_t)packetId {
    return 0x1C;
}

- (OFDataArray *)packetData {
    OFDataArray *packetData = [OFDataArray dataArray];
    
    [packetData appendLong:self.pingId];
    [packetData appendLong:self.serverId];
    [packetData appendMagic];
    [packetData appendStringUdp:self.identifier];
    
    return packetData;
}

@end
