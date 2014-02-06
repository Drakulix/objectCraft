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
static OFMutableArray *activeTCPConnections;

@implementation TCPClientConnection

- (instancetype)initWithSocket:(OFTCPSocket *)_socket {
    self = [super init];
    
    @try {
        @autoreleasepool {
            packetHandler = [[TCPPacketHandler alloc] initWithDelegate:[[[TCPHandshakeHandler alloc] initWithClientConnection:self] autorelease]];
        }
        socket = [_socket retain];
        [socket setWriteBufferEnabled:NO];
        [socket asyncReadVarIntForTarget:self selector:@selector(readFrom:varInt:error:)];
        
    } @catch (id e) {
        [self release];
        @throw e;
    }
    
    return self;
}


- (void)disconnectClient {
    [packetHandler.delegate clientDisconnected];
    [socket cancelAsyncRequests];
    [socket close];
    [server tcpClientDisconnected:self];
}

- (void)dealloc {
    [packetHandler release];
    [socket release];
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


- (void)readFrom:(OFStream *)stream varInt:(uint64_t)varInt error:(OFException *)exception {
    
    if (exception) {
        if ([exception isKindOfClass:[OFNotConnectedException class]]) {
            LogInfo(@"Client Disconnected: %@", [socket remoteAddress]);
        } else {
            LogError(@"Error reading from Socket: %@", socket);
        }
        [self disconnectClient];
        return;
    }
    
    void *buffer = malloc(varInt);
    [socket asyncReadIntoBuffer:buffer exactLength:varInt target:self selector:@selector(readFrom:packet:withSize:error:)];
    
}

- (BOOL)readFrom:(OFStream *)stream packet:(void *)buffer withSize:(size_t)size error:(OFException *)exception {
    
    if (exception) {
        if ([exception isKindOfClass:[OFNotConnectedException class]]) {
            LogInfo(@"Client Disconnected: %@", [socket remoteAddress]);
        } else {
            LogError(@"Error reading from Socket: %@", socket);
        }
        [self disconnectClient];
        return NO;
    }
    
    @autoreleasepool {
        OFDataArray *data = [OFDataArray dataArrayWithItemSize:1 capacity:size];
        [data addItems:buffer count:size];
        [packetHandler recievedPacket:data];
    }
    
    free(buffer);
    [socket asyncReadVarIntForTarget:self selector:@selector(readFrom:varInt:error:)];
    
    return NO;
}

@end
