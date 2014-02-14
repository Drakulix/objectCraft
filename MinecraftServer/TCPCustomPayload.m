//
//  TCPCustomPayload.m
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 06.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "TCPCustomPayload.h"
#import "OFDataArray+IntWriter.h"
#import "OFDataArray+StringWriter.h"

@implementation TCPCustomPayload

- (instancetype)initWithChannel:(OFString *)channel payload:(OFDataArray *)data {
    self = [super init];
    @try {
        self.channel = channel;
        self.length = [data count];
        self.payload = data;
    } @catch (id e) {
        [self release];
        @throw e;
    }
    return self;
}

+ (uint64_t)packetId {
    return 0x3F;
}

- (OFDataArray *)packetData {
    OFDataArray *packetData = [OFDataArray dataArray];
    [packetData appendStringTcp:self.channel];
    [packetData appendShort:self.length];
    [packetData addItems:[self.payload items] count:[self.payload count]];
    return packetData;
}


@end
