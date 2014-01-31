//
//  UDPRecieveThread.m
//  MinecraftServer
//
//  Created by Victor Brekenfeld on 28.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "UDPRecieveThread.h"
#import "RaknetHandler.h"

@implementation UDPRecieveThread

#define MAX_PACKET_SIZE 1504 //MAX MTU is 1447. 1504 bytes should never be too small

- (instancetype)initWithUDPSocket:(OFUDPSocket *)_socket {
    self = [super init];
    if (self) {
        socket = _socket;
        running = YES;
        raknetHandler = [[RaknetHandler alloc] initWithSocket:socket];
    }
    return self;
}

- (id)main {
    void *buffer = malloc(MAX_PACKET_SIZE);
    of_udp_socket_address_t peer;
    size_t length;
    
    while (running) {
        length = [socket receiveIntoBuffer:buffer length:MAX_PACKET_SIZE sender:&peer];
        
        OFDataArray *data = [[OFDataArray alloc] initWithCapacity:length];
        [data addItems:buffer count:length];
        
        //TO-DO check for (custom!) disconnect packet (means we shutdown the hole server) - if yes, call shutdown / escape from while loop
        
        [raknetHandler didRecieveData:data fromPeer:peer];
    }
    
    free(buffer);
    return nil;
}

- (void)shutdown {
    running = NO;
}

@end
