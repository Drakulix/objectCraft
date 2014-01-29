//
//  UDPClientHandshake.m
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 10.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "UDPClientHandshake.h"

@implementation UDPClientHandshake

- (instancetype)initWithData:(NSData *)data {
    self = [super init];
    if (self) {
        NSMutableData *packetData = [data mutableCopy];
        
        self.cookie = [packetData readInt];
        self.security = [packetData readByte];
        
        self.port = [packetData readShort];
        
        uint8_t dataLen = [packetData readByte];
        self.dataArray0 = [packetData subdataWithRange:NSMakeRange(0, dataLen)];
        [packetData replaceBytesInRange:NSMakeRange(0, dataLen) withBytes:NULL length:0];
        
        NSMutableData *dataArrayTmp = [[NSMutableData alloc] init];
        for (int i = 0; i<9; i++) {
            uint24_t len = [packetData readUInt24];
            [dataArrayTmp appendUInt24:len];
            [dataArrayTmp appendData:[packetData subdataWithRange:NSMakeRange(0, len.i)]];
            [packetData replaceBytesInRange:NSMakeRange(0, len.i) withBytes:NULL length:0];
        }
        self.dataArray = dataArrayTmp;
        
        self.timeStamp = [packetData readShort];
        self.session2 = [packetData readLong];
        self.session = [packetData readLong];
    }
    return self;
}

+ (uint8_t)packetId {
    return 0x13;
}

- (NSData *)packetData {
    NSMutableData *packetData = [[NSMutableData alloc] init];
    [packetData appendInt:self.cookie];
    [packetData appendByte:self.security];
    [packetData appendShort:self.port];
    
    [packetData appendByte:[self.dataArray0 length]];
    [packetData appendData:self.dataArray0];
    [packetData appendData:self.dataArray];
    
    [packetData appendShort:self.timeStamp];
    [packetData appendLong:self.session2];
    [packetData appendLong:self.session];
    
    return packetData;
}

@end
