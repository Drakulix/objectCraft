//
//  TCPStatusHandler.h
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 05.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import <ObjFW/ObjFW.h>
#import "TCPPacketHandler.h"
@class TCPClientConnection;

@interface TCPStatusHandler : OFObject<TCPPacketDelegate> {
    TCPClientConnection *connectionDelegate;
}

- (instancetype)initWithClientConnection:(TCPClientConnection *)client;

@end
