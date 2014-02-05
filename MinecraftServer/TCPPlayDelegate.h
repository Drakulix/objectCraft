//
//  TCPPlayDelegate.h
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 05.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import <ObjFW/ObjFW.h>
#import "TCPPacketHandler.h"
@class TCPClientConnection;
@class Player;

@interface TCPPlayDelegate : OFObject<TCPPacketDelegate> {
    TCPClientConnection *connectionDelegate;
    Player *player;
}

- (instancetype)initWithClientConnection:(TCPClientConnection *)client withPlayer:(Player *)player;

@end