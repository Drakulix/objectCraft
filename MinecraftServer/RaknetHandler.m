//
//  RaknetHandler.m
//  MinecraftServer
//
//  Created by Victor Brekenfeld on 28.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "RaknetHandler.h"
#import "OFDataArray+IntReader.h"

@implementation RaknetHandler

- (void)didRecieveData:(OFDataArray *)data fromPeer:(of_udp_socket_address_t)address {
    uint8_t packetId = [data readByte];
    
}

@end
