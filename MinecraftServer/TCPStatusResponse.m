//
//  TCPStatusResponse.m
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 10.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "TCPStatusResponse.h"
#import "OFDataArray+StringWriter.h"

@implementation TCPStatusResponse
@synthesize json;

- (instancetype)initWithDictionary:(OFDictionary *)dictionary {
    self = [super init];
    @try {
        self.json = dictionary;
    } @catch (id e) {
        [self release];
        @throw e;
    }
    return self;
}

+ (int)state {
    return 1;
}

+ (uint64_t)packetId {
    return 0x00;
}

- (OFDataArray *)packetData {
    OFDataArray *packetData = [OFDataArray dataArray];
    [packetData appendStringTcp:[self.json JSONRepresentation]];
    return packetData;
}

@end
