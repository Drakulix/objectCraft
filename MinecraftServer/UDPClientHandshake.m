//
//  UDPClientHandshake.m
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 10.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "UDPClientHandshake.h"
#import "OFDataArray+IntReader.h"
#import "OFDataArray+IntWriter.h"

@implementation UDPClientHandshake

- (instancetype)initWithData:(OFDataArray *)data {
    self = [super init];
    if (self) {
        self.cookie = [data readInt];
        self.security = [data readByte];
        
        self.port = [data readShort];
        
        uint8_t dataLen = [data readByte];
        self.dataArray0 = [[OFDataArray alloc] initWithCapacity:dataLen];
        [self.dataArray0 addItems:[data firstItem] count:dataLen];
        [data removeItemsInRange:of_range(0, dataLen)];
        
        OFDataArray *dataArrayTmp = [[OFDataArray alloc] init];
        for (int i = 0; i<9; i++) {
            uint24_t len = [data readUInt24];
            [dataArrayTmp appendUInt24:len];
            [dataArrayTmp addItems:[data firstItem] count:len.i];
            [data removeItemsInRange:of_range(0, len.i)];
        }
        self.dataArray = dataArrayTmp;
        
        self.timeStamp = [data readShort];
        self.session2 = [data readLong];
        self.session = [data readLong];
    }
    return self;
}

+ (uint8_t)packetId {
    return 0x13;
}

- (OFDataArray *)packetData {
    OFDataArray *packetData = [[OFDataArray alloc] init];
    [packetData appendInt:self.cookie];
    [packetData appendByte:self.security];
    [packetData appendShort:self.port];
    
    [packetData appendByte:[self.dataArray0 count]];
    [packetData addItems:[self.dataArray0 firstItem] count:[self.dataArray0 count]];
    [packetData addItems:[self.dataArray firstItem] count:[self.dataArray count]];
    
    [packetData appendShort:self.timeStamp];
    [packetData appendLong:self.session2];
    [packetData appendLong:self.session];
    
    return packetData;
}

@end
