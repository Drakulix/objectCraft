//
//  TCPLoginSuccess.m
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 05.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "TCPLoginSuccess.h"
#import "OFDataArray+StringWriter.h"

@implementation TCPLoginSuccess

- (instancetype)initWithUUID:(OFString *)uuid Username:(OFString *)username {
    self = [super init];
    if (self) {
        self.uuid = uuid;
        self.username = username;
    }
    return self;
}

+ (int)state {
    return 2;
}

+ (uint64_t)packetId {
    return 0x02;
}

- (OFDataArray *)packetData {
    OFDataArray *packetData = [[OFDataArray alloc] init];
    [packetData appendStringTcp:self.uuid];
    [packetData appendStringTcp:self.username];
    return packetData;
}

@end
