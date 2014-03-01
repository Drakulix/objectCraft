//
//  RaknetCustomPacket.h
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 09.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import <ObjFW/ObjFW.h>
#import "RaknetPacket.h"
#import "RaknetMinecraftPacket.h"
#import "int24_t.h"
@class UDPClientConnection;

@interface RaknetCustomPacket : RaknetPacket {
    uint24_t packetNumber;
    
    //dispatch stuff
    UDPClientConnection *handler;
}

@property (nonatomic) uint32_t packetNumber;
@property (nonatomic, retain) OFMutableArray *packets;


- (void)dispatchNewTransmissionVia:(UDPClientConnection *)handler;
- (void)resend;
- (void)setPacketNumber24:(uint24_t)packetNumber;

@end
