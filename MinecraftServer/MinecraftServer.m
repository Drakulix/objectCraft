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
        [tcpServerSocket bindToHost:@"0.0.0.0" port:[ConfigManager defaultManager].tcpPort];
        [tcpServerSocket listen];
        
        [tcpServerSocket asyncAcceptWithBlock:^bool(OFTCPSocket *socket, OFTCPSocket *acceptedSocket, OFException *exception) {

            if (exception) {
                LogError(@"Exception on accepting tcp socket: %@", exception);
                return true;
            }
            
            TCPClientConnection *conn = [[TCPClientConnection alloc] initWithSocket:acceptedSocket fromMinecraftServer:self];
            [activeTCPConnections addObject:conn];
            [conn release];
            
            return true;
        
        }];
    }
    @catch (OFException *exception) {
        LogError(@"Exception on creating TCP socket: %@", exception);
        [OFApplication terminateWithStatus:EXIT_FAILURE];
    }
    
    @try {
        udpServerSocket = [[OFUDPSocket alloc] init];
        [udpServerSocket bindToHost:@"0.0.0.0" port:[ConfigManager defaultManager].udpPort];
        raknetHandler = [[RaknetHandler alloc] initWithSocket:udpServerSocket];
        udpServerSocketBuffer = malloc(UDP_MAX_PACKET_SIZE);
        
        [udpServerSocket asyncReceiveIntoBuffer:udpServerSocketBuffer length:UDP_MAX_PACKET_SIZE block:^bool(OFUDPSocket *socket, void *buffer, size_t length, of_udp_socket_address_t sender, OFException *exception) {
            
            if (exception) {
                LogError(@"Exception on reading from udp socket: %@", exception);
                return true;
            }
            
            OFDataArray *data = [[OFDataArray alloc] initWithCapacity:length];
            [data addItems:buffer count:length];
            
            [raknetHandler didRecieveData:data fromPeer:sender];
            return true;
        
        }];
    }
    @catch (OFException *exception) {
        LogError(@"Exception on creating UDP socket: %@", exception);
        [OFApplication terminateWithStatus:EXIT_FAILURE];
    }
    
    LogInfo(@"ObjectCraft Server started");
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
