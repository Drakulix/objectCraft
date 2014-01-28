//
//  UDPRecieveThread.h
//  MinecraftServer
//
//  Created by Victor Brekenfeld on 28.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import <ObjFW/ObjFW.h>
@class RaknetHandler;

@interface UDPRecieveThread : OFThread {
    @private
    OFUDPSocket *socket;
    BOOL running;
    
    RaknetHandler *raknetHandler;
}

- (instancetype)initWithUDPSocket:(OFUDPSocket *)socket;
- (void)shutdown;

@end
