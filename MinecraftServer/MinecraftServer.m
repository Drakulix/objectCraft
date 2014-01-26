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
    
    activeTCPConnections = [[OFMutableArray alloc] init];
    
    @try {
        tcpServerSocketIPv4 = [[OFTCPSocket alloc] init];
        [tcpServerSocketIPv4 bindToHost:@"0.0.0.0" port:[[ConfigManager sharedInstance] tcpIPv4Port]];
        [tcpServerSocketIPv4 listen];
        [tcpServerSocketIPv4 asyncAcceptWithTarget:self selector:@selector(acceptFrom:On:withException:)];
    }
    @catch (OFException *exception) {
        LogError(@"Exception on creating IPv4 socket: %@", exception);
        [OFApplication terminateWithStatus:EXIT_FAILURE];
    }
    
    @try {
        tcpServerSocketIPv6 = [[OFTCPSocket alloc] init];
        [tcpServerSocketIPv6 bindToHost:@"::" port:[[ConfigManager sharedInstance] tcpIPv6Port]];
        [tcpServerSocketIPv6 listen];
        [tcpServerSocketIPv6 asyncAcceptWithTarget:self selector:@selector(acceptFrom:On:withException:)];
    }
    @catch (OFException *exception) {
        LogError(@"Exception on creating IPv6 socket: %@", exception);
        [OFApplication terminateWithStatus:EXIT_FAILURE];
    }
    
    LogInfo(@"ObjectCraft Server started");
}

- (BOOL)acceptFrom:(OFTCPSocket *)socket On:(OFTCPSocket *)acceptedSocket withException:(OFException *)exception {
    if (exception) {
        LogError(@"Exception on accepting socket: %@", exception);
        return false;
    }
    
    return true;
}

- (void)applicationWillTerminate {
    
}

@end
