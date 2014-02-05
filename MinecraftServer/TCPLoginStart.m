//
//  TCPLoginStart.m
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 05.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "TCPLoginStart.h"
#import "OFDataArray+StringReader.h"

@implementation TCPLoginStart

- (instancetype)initWithData:(OFDataArray *)data {
    self = [super init];
    if (self) {
        _username = [data readStringTcp];
    }
    return self;
}

+ (int)state {
    return 2;
}

+ (uint64_t)packetId {
    return 0x00;
}

@end
