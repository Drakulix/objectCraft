//
//  TCPPacketHandler.h
//  MinecraftServer
//
//  Created by Victor Brekenfeld on 03.02.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import <ObjFW/ObjFW.h>

@class TCPPacket;
@class TCPPacketHandler;
@protocol TCPPacketDelegate <OFObject>
- (void)recievedPacket:(TCPPacket *)packet;
- (void)clientDisconnected;
- (int)state;
@end

@interface TCPPacketHandler : OFObject

@property (retain) id<TCPPacketDelegate> delegate;

- (instancetype)initWithDelegate:(id<TCPPacketDelegate>)delegate;
- (void)recievedPacket:(OFDataArray *)data;

@end