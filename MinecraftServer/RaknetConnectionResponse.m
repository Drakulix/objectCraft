//
//  RaknetConnectionResponse.m
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 08.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "RaknetConnectionResponse.h"
#import "ConfigManager.h"
#import "OFDataArray+IntReader.h"
#import "OFDataArray+IntWriter.h"
#import "OFDataArray+RaknetMagic.h"

@implementation RaknetConnectionResponse

- (instancetype)initWithMtuSize:(int16_t)mtuSize {
    self = [super init];
    @try {
        self.serverId = [ConfigManager defaultManager].udpServerId;
        self.serverSecurity = 0;
        self.mtuSize = mtuSize;
    } @catch (id e) {
        [self release];
        @throw e;
    }
    return self;
}

- (instancetype)initWithData:(OFDataArray *)data {
    self = [super init];
    @try {
        if (![data checkMagic]) {
            [self release];
            return nil;
        }
        self.serverId = [data readLong];
        self.serverSecurity = [data readByte];
        self.mtuSize = [data readShort];
    } @catch (id e) {
        [self release];
        @throw e;
    }
    return self;
}

+ (uint8_t)packetId {
    return 0x06;
}

- (OFDataArray *)packetData {
    OFDataArray *packetData = [OFDataArray dataArray];
    
    [packetData appendMagic];
    [packetData appendLong:self.serverId];
    [packetData appendByte:self.serverSecurity];
    [packetData appendShort:self.mtuSize];
    
    return packetData;
}

@end
