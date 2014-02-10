//
//  TCPClientConnection.m
//  MinecraftServer
//
//  Created by Victor Brekenfeld on 03.02.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "log.h"
#import "TCPClientConnection.h"
#import "TCPPacketHandler.h"
#import "TCPServerPacket.h"
#import "TCPHandshakeHandler.h"
#import "OFDataArray+VarIntReader.h"
#import "MinecraftServer.h"
#import <dispatch/dispatch.h>

@implementation TCPClientConnection

- (instancetype)initWithSocket:(OFTCPSocket *)_socket fromMinecraftServer:(MinecraftServer *)_server {
    self = [super init];
    
    @try {
        @autoreleasepool {
            packetHandler = [[TCPPacketHandler alloc] initWithDelegate:[[[TCPHandshakeHandler alloc] initWithClientConnection:self] autorelease]];
        }
        server = _server;
        socket = _socket;
        [socket setWriteBufferEnabled:NO];
        
        packetReadCallback = [^bool(OFStream *stream, void *buffer, size_t length, OFException *exception) {
            
            if (exception) {
                LogError(@"Error reading from tcp Socket: %@ with Exception: %@", socket, exception);
                [self clientDisconnected];
                return NO;
            }
            
            @autoreleasepool {
                OFDataArray *data = [OFDataArray dataArrayWithItemSize:1 capacity:length];
                [data addItems:buffer count:length];
                [packetHandler recievedPacket:data];
            }
            
            free(buffer);
            
            [self readPacketId];
            
            return NO;
            
        } copy];
        
        varIntReadCallback = [^bool(OFStream *stream, uint64_t varInt, OFException *exception) {
            
            if (exception) {
                LogError(@"Error reading from tcp Socket: %@ with Exception: %@", socket, exception);
                [self clientDisconnected];
                return YES;
            }
            
            void *buffer = malloc(varInt);
            [socket asyncReadIntoBuffer:buffer exactLength:varInt block:packetReadCallback];
            return NO;
            
        } copy];
        
        [self readPacketId];
    } @catch (id e) {
        [self release];
        @throw e;
    }
    
    return self;
}

- (void)readPacketId {
    [socket asyncReadVarIntWithBlock:varIntReadCallback];
}

- (void)disconnectClient {
    [socket cancelAsyncRequests];
    [socket close];
    [self clientDisconnected];
}

- (void)clientDisconnected {
    [packetHandler.delegate clientDisconnected];
    packetHandler.delegate = nil;
    [varIntReadCallback release];
    [packetReadCallback release];
    [server tcpClientDisconnected:self];
}

- (void)dealloc {
    [packetHandler release];
    [super dealloc];
}

- (void)changeDelegate:(id<TCPPacketDelegate>)delegate {
    packetHandler.delegate = delegate;
}


- (void)sendPacket:(TCPServerPacket *)packet {
    LogDebug(@"sending Packet: %@", packet);
    LogVerbose(@"%@", [packet rawPacketData]);
    [socket writeDataArray:[packet rawPacketData]];
}

@end
