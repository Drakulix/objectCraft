//
//  UDPDisconnect.m
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 19.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "UDPDisconnect.h"

@implementation UDPDisconnect

- (instancetype)initWithData:(NSData *)data {
    return [super init];
}

+ (uint8_t)packetId {
    return 0x15;
}

- (NSData *)packetData {
    return [NSData data];
}

@end
