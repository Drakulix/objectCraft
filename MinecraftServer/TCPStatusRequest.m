//
//  TCPStatusRequest.m
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 10.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "TCPStatusRequest.h"

@implementation TCPStatusRequest

+ (int)state {
    return 1;
}

+ (uint64_t)packetId {
    return 0x00;
}

@end
