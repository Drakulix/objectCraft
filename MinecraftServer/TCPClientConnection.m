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
static OFMutableArray *activeTCPConnections;

@implementation TCPClientConnection

- (instancetype)initWithSocket:(OFTCPSocket *)_socket {
    self = [super init];
    if (self) {
        
        packetHandler = [[TCPPacketHandler alloc] initWithDelegate:[[TCPHandshakeHandler alloc] initWithClientConnection:self]];
        socket = _socket;
        [socket setWriteBufferEnabled:NO];
        [socket asyncReadVarIntForTarget:self selector:@selector(readFrom:varInt:error:)];
        
        if (!activeTCPConnections) {
            activeTCPConnections = [[OFMutableArray alloc] init];
        }
        [activeTCPConnections addObject:self];
        
    }
    return self;
}


- (void)disconnectClient {
    [packetHandler.delegate clientDisconnected];
    [socket cancelAsyncRequests];
    [socket close];
    [activeTCPConnections removeObject:self];
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
        //TO-DO if not-connected exception
        LogError(@"Error reading from Socket: %@", socket);
        return;
    }
    
    void *buffer = malloc(varInt);
    [socket asyncReadIntoBuffer:buffer exactLength:varInt target:self selector:@selector(readFrom:packet:withSize:error:)];
    
}

- (BOOL)readFrom:(OFStream *)stream packet:(void *)buffer withSize:(size_t)size error:(OFException *)exception {
    
    if (exception) {
        //TO-DO if not-connected exception
        LogError(@"Error reading from Socket: %@", socket);
        return NO;
    }
    
    OFDataArray *data = [OFDataArray dataArrayWithItemSize:1 capacity:size];
    [data addItems:buffer count:size];
    [packetHandler recievedPacket:data];
    free(buffer);
    [socket asyncReadVarIntForTarget:self selector:@selector(readFrom:varInt:error:)];
    
    return NO;
}

@end
