//
//  UDPServerHandshake.m
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 09.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "UDPServerHandshake.h"

@implementation UDPServerHandshake

- (instancetype)initWithPort:(uint16_t)port sessionId:(int64_t)session serverSessionId:(int64_t)session2 {
    self = [super init];
    if (self) {
        self.cookie = 0x043f57fe;
        self.security = 0xcd;
        self.port = port;
        NSMutableData *data = [[NSMutableData alloc] init];
        uint24_t len;
        len.i = 4;
        [data appendUInt24:len];
        [data appendInt:0xf5fffff5];
        for (int i = 0; i<9; i++) {
            [data appendUInt24:len];
            [data appendInt:0xffffffff];
        }
        self.dataArray = data;
        self.timeStamp = 0x0000;
        self.session = session;
        self.session2 = session2;
    }
    return self;
}

- (instancetype)initWithData:(NSData *)data {
    self = [super init];
    if (self) {
        NSMutableData *packetData = [data mutableCopy];
        self.cookie = [packetData readInt];
        self.security = [packetData readByte];
        self.port = [packetData readShort];
        
        NSMutableData *dataArrayTmp = [[NSMutableData alloc] init];
        for (int i = 0; i<10; i++) {
            [dataArrayTmp appendUInt24:[packetData readUInt24]];
            [dataArrayTmp appendInt:[packetData readInt]];
        }
        self.dataArray = dataArrayTmp;
        
        self.timeStamp = [packetData readShort];
        self.session = [packetData readLong];
        self.session2 = [packetData readLong];
    }
    return self;
}

+ (uint8_t)packetId {
    return 0x10;
}

- (NSData *)packetData {
    NSMutableData *packetData = [[NSMutableData alloc] init];
    
    [packetData appendInt:self.cookie];
    [packetData appendByte:self.security];
    [packetData appendShort:self.port];
    
    [packetData appendData:self.dataArray];
    [packetData appendShort:self.timeStamp];
    
    [packetData appendLong:self.session];
    [packetData appendLong:self.session2];
    
    return packetData;
}

@end
