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
#import "TCPClientConnection.h"

#import "RaknetPacket.h"
#import "UDPPacket.h"
#import "TCPClientPacket.h"

@implementation MinecraftServer

- (void)applicationDidFinishLaunching {
    
    worldManager = [WorldManager defaultManager];
    
    activeTCPConnections = [[OFMutableArray alloc] init];
    
    [RaknetPacket setup];
    [UDPPacket setup];
    [TCPClientPacket setup];
    
    @try {
        tcpServerSocket = [[OFTCPSocket alloc] init];
        [tcpServerSocket bindToHost:@"0.0.0.0" port:[ConfigManager defaultManager].tcpIPv4Port];
        [tcpServerSocket listen];
        [tcpServerSocket asyncAcceptWithTarget:self selector:@selector(acceptFrom:On:withException:)];
    }
    @catch (OFException *exception) {
        LogError(@"Exception on creating TCP socket: %@", exception);
        [OFApplication terminateWithStatus:EXIT_FAILURE];
    }
    
    @try {
        udpServerSocket = [[OFUDPSocket alloc] init];
        [udpServerSocket bindToHost:@"0.0.0.0" port:[ConfigManager defaultManager].udpIPv4Port];
        raknetHandler = [[RaknetHandler alloc] initWithSocket:udpServerSocketIPv4];
        udpServerSocketBuffer = malloc(UDP_MAX_PACKET_SIZE);
        [udpServerSocket asyncReceiveIntoBuffer:udpServerSocketIPv4Buffer length:UDP_MAX_PACKET_SIZE target:self selector:@selector(recieveViaUDPSocket:data:withSize:from:error:)];
    }
    @catch (OFException *exception) {
        LogError(@"Exception on creating UDP socket: %@", exception);
        [OFApplication terminateWithStatus:EXIT_FAILURE];
    }
    
    LogInfo(@"ObjectCraft Server started");
}

- (bool)recieveViaUDPSocket:(OFUDPSocket *)socket data:(void *)buffer withSize:(size_t)length from:(of_udp_socket_address_t)peer error:(OFException *)exception {
    if (exception) {
        LogError(@"Exception on reading from udp socket: %@", exception);
        return true;
    }
    
    OFDataArray *data = [[OFDataArray alloc] initWithCapacity:length];
    [data addItems:buffer count:length];
    
    [raknetHandler didRecieveData:data fromPeer:peer];
    return true;
}

- (bool)acceptFrom:(OFTCPSocket *)socket On:(OFTCPSocket *)acceptedSocket withException:(OFException *)exception {
    if (exception) {
        LogError(@"Exception on accepting tcp socket: %@", exception);
        return true;
    }
    
    TCPClientConnection *conn = [[TCPClientConnection alloc] initWithSocket:acceptedSocket fromMinecraftServer:self];
    [activeTCPConnections addObject:conn];
    [conn release];
    
    return true;
}

- (void)tcpClientDisconnected:(TCPClientConnection *)tcpClientConnection {
    [activeTCPConnections removeObject:tcpClientConnection];
}

- (void)applicationWillTerminate {
    
    LogInfo(@"Shutting down");
    
    for (TCPClientConnection *connection in activeTCPConnections) {
        [connection disconnectClient];
    }
    [activeTCPConnections release];
    
    [worldManager shutdown];
    
    [tcpServerSocket close];
    [tcpServerSocket release];
    
    [udpServerSocket cancelAsyncRequests];
    [udpServerSocket close];
    [udpServerSocket release];
    free(udpServerSocketBuffer);
}

@end
