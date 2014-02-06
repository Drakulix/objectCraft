//
//  TCPPing.m
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 07.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "TCPPing.h"
#import "OFDataArray+IntWriter.h"
#include <time.h>
#include <stdlib.h>

@implementation TCPPing

+ (void)initialize {
    srand((unsigned int)time(NULL));
}

+ (uint64_t)packetId {
    return 0x00;
}

- (OFDataArray *)packetData {
    OFDataArray *packetData = [OFDataArray dataArray];
    int r = rand();
    [packetData appendInt:r];
    return packetData;
}

@end
