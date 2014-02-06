//
//  UDPServerHandshake.m
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 09.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "UDPServerHandshake.h"
#import "OFDataArray+IntReader.h"
#import "OFDataArray+IntWriter.h"

@implementation UDPServerHandshake

- (instancetype)initWithPort:(uint16_t)port sessionId:(int64_t)session serverSessionId:(int64_t)session2 {
    self = [super init];
    @try {
        
        self.cookie = 0x043f57fe;
        self.security = 0xcd;
        self.port = port;
        
        OFDataArray *data = [OFDataArray dataArray];
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
        
    } @catch (id e) {
        [self release];
        @throw e;
    }
    
    return self;
}

- (instancetype)initWithData:(OFDataArray *)data {
    self = [super init];
    @try {
        
        self.cookie = [data readInt];
        self.security = [data readByte];
        self.port = [data readShort];
        
        OFDataArray *dataArrayTmp = [OFDataArray dataArrayWithCapacity:sizeof(int8_t)*3+sizeof(int32_t)];
        for (int i = 0; i<10; i++) {
            [dataArrayTmp appendUInt24:[data readUInt24]];
            [dataArrayTmp appendInt:[data readInt]];
        }
        self.dataArray = dataArrayTmp;
        
        self.timeStamp = [data readShort];
        self.session = [data readLong];
        self.session2 = [data readLong];
    
    } @catch (id e) {
        [self release];
        @throw e;
    }
    return self;
}

+ (uint8_t)packetId {
    return 0x10;
}

- (OFDataArray *)packetData {
    OFDataArray *packetData = [OFDataArray dataArray];
    
    [packetData appendInt:self.cookie];
    [packetData appendByte:self.security];
    [packetData appendShort:self.port];
    
    [packetData addItems:[self.dataArray firstItem] count:[self.dataArray count]];
    [packetData appendShort:self.timeStamp];
    
    [packetData appendLong:self.session];
    [packetData appendLong:self.session2];
    
    return packetData;
}

@end
