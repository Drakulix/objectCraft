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
@synthesize uuid, username;

- (instancetype)initWithUUID:(OFString *)_uuid Username:(OFString *)_username {
    self = [super init];
    @try {
        self.uuid = _uuid;
        self.username = _username;
    } @catch (id e) {
        [self release];
        @throw e;
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
    OFDataArray *packetData = [OFDataArray dataArray];
    [packetData appendStringTcp:self.uuid];
    [packetData appendStringTcp:self.username];
    return packetData;
}

@end
