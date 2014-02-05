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

- (instancetype)initWithDictionary:(OFDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.json = dictionary;
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
    OFDataArray *packetData = [[OFDataArray alloc] init];
    [packetData appendStringTcp:[self.json JSONRepresentation]];
    return packetData;
}

@end
