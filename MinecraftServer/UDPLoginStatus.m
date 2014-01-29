//
//  UDPLoginStatus.m
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 10.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "UDPLoginStatus.h"

@implementation UDPLoginStatus

- (instancetype)initWithStatus:(int32_t)status {
    self = [super init];
    if (self) {
        self.status = status;
    }
    return self;
}

- (instancetype)initWithData:(NSData *)data {
    self = [super init];
    if (self) {
        NSMutableData *packetData = [data mutableCopy];
        self.status = [packetData readInt];
    }
    return self;
}

+ (uint8_t)packetId {
    return 0x83;
}

- (NSData *)packetData {
    NSMutableData *packetData = [[NSMutableData alloc] init];
    [packetData appendInt:self.status];
    return packetData;
}

@end
