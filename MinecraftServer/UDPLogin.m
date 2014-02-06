//
//  UDPLoginPacket.m
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 09.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "UDPLogin.h"
#import "OFDataArray+IntReader.h"
#import "OFDataArray+IntWriter.h"
#import "OFDataArray+StringReader.h"
#import "OFDataArray+StringWriter.h"

@implementation UDPLogin

- (instancetype)initWithData:(OFDataArray *)data {
    self = [super init];
    @try {
    
        self.username = [data readStringUdp];
        self.protocol1 = [data readInt];
        self.protocol2 = [data readInt];
        self.clientId = [data readInt];
        self.realmsData = [data readStringUdp];
    
    } @catch (id e) {
        [self release];
        @throw e;
    }
    return self;
}

+ (uint8_t)packetId {
    return 0x82;
}

- (OFDataArray *)packetData {
    OFDataArray *packetData = [OFDataArray dataArray];
    
    [packetData appendStringUdp:self.username];
    [packetData appendInt:self.protocol1];
    [packetData appendInt:self.protocol2];
    [packetData appendInt:self.clientId];
    [packetData appendStringUdp:self.realmsData];
    
    return packetData;
}

@end
