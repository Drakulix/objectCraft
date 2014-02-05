//
//  MinecraftServer.m
//  MinecraftServer
//
//  Created by Victor Brekenfeld on 22.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "log.h"

#import "MinecraftServer.h"
#import "ConfigManager.h"
#import "WorldManager.h"
#import "RaknetHandler.h"

#import "RaknetPacket.h"
#import "UDPPacket.h"

static MinecraftServer *sharedInstance;

@implementation MinecraftServer

+ (MinecraftServer *)sharedInstance {
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        sharedInstance = self;
        
    }
    return self;
}

- (void)applicationDidFinishLaunching {
    
    worldManager = [WorldManager defaultManager];
    
    activeTCPConnections = [[OFMutableArray alloc] init];
    
    [RaknetPacket setup];
    [UDPPacket setup];
    
    @try {
        tcpServerSocketIPv4 = [[OFTCPSocket alloc] init];
        [tcpServerSocketIPv4 bindToHost:@"0.0.0.0" port:[ConfigManager defaultManager].tcpIPv4Port];
        [tcpServerSocketIPv4 listen];
        [tcpServerSocketIPv4 asyncAcceptWithTarget:self selector:@selector(acceptFrom:On:withException:)];
    }
    @catch (OFException *exception) {
        LogError(@"Exception on creating TCP IPv4 socket: %@", exception);
        [OFApplication terminateWithStatus:EXIT_FAILURE];
    }
    
    @try {
        tcpServerSocketIPv6 = [[OFTCPSocket alloc] init];
        [tcpServerSocketIPv6 bindToHost:@"::" port:[ConfigManager defaultManager].tcpIPv6Port];
        [tcpServerSocketIPv6 listen];
        [tcpServerSocketIPv6 asyncAcceptWithTarget:self selector:@selector(acceptFrom:On:withException:)];
    }
    @catch (OFException *exception) {
        LogError(@"Exception on creating TCP IPv6 socket: %@", exception);
        [OFApplication terminateWithStatus:EXIT_FAILURE];
    }
    
    @try {
        udpServerSocketIPv4 = [[OFUDPSocket alloc] init];
        [udpServerSocketIPv4 bindToHost:@"0.0.0.0" port:[ConfigManager defaultManager].udpIPv4Port];
        raknetHandlerIPv4 = [[RaknetHandler alloc] initWithSocket:udpServerSocketIPv4];
        udpServerSocketIPv4Buffer = malloc(UDP_MAX_PACKET_SIZE);
        [udpServerSocketIPv4 asyncReceiveIntoBuffer:udpServerSocketIPv4Buffer length:UDP_MAX_PACKET_SIZE target:self selector:@selector(recieveViaUDPSocket:data:withSize:from:error:)];
    }
    @catch (OFException *exception) {
        LogError(@"Exception on creating UDP IPv4 socket: %@", exception);
        [OFApplication terminateWithStatus:EXIT_FAILURE];
    }
    @try {
        udpServerSocketIPv6 = [[OFUDPSocket alloc] init];
        [udpServerSocketIPv6 bindToHost:@"::" port:[ConfigManager defaultManager].udpIPv6Port];
        raknetHandlerIPv6 = [[RaknetHandler alloc] initWithSocket:udpServerSocketIPv6];
        udpServerSocketIPv6Buffer = malloc(UDP_MAX_PACKET_SIZE);
        [udpServerSocketIPv6 asyncReceiveIntoBuffer:udpServerSocketIPv6Buffer length:UDP_MAX_PACKET_SIZE target:self selector:@selector(recieveViaUDPSocket:data:withSize:from:error:)];
    }
    @catch (OFException *exception) {
        LogError(@"Exception on creating UDP IPv6 socket: %@", exception);
        [OFApplication terminateWithStatus:EXIT_FAILURE];
    }
    
    LogInfo(@"ObjectCraft Server started");
}

- (BOOL)recieveViaUDPSocket:(OFUDPSocket *)socket data:(void *)buffer withSize:(size_t)length from:(of_udp_socket_address_t)peer error:(OFException *)exception {
    if (exception) {
        LogError(@"Exception on reading from udp socket: %@", exception);
        return YES;
    }
    
    OFDataArray *data = [[OFDataArray alloc] initWithCapacity:length];
    [data addItems:buffer count:length];
    
    if (socket == udpServerSocketIPv4)
        [raknetHandlerIPv4 didRecieveData:data fromPeer:peer];
    else
        [raknetHandlerIPv6 didRecieveData:data fromPeer:peer];
    
    return YES;
}

- (BOOL)acceptFrom:(OFTCPSocket *)socket On:(OFTCPSocket *)acceptedSocket withException:(OFException *)exception {
    if (exception) {
        LogError(@"Exception on accepting tcp socket: %@", exception);
        return YES;
    }
    
    return YES;
}

- (void)applicationWillTerminate {
    
    LogInfo(@"Shutting down");
    
    [tcpServerSocketIPv4 close];
    [tcpServerSocketIPv6 close];
    
    [udpServerSocketIPv4 cancelAsyncRequests];
    [udpServerSocketIPv6 cancelAsyncRequests];
    [udpServerSocketIPv4 close];
    [udpServerSocketIPv6 close];
    free(udpServerSocketIPv4Buffer);
    free(udpServerSocketIPv6Buffer);
}

@end
