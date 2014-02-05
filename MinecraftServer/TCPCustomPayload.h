//
//  TCPCustomPayload.h
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 06.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import <ObjFW/ObjFW.h>
#import "TCPServerPacket.h"

@interface TCPCustomPayload : TCPServerPacket

@property (retain) OFString *channel;
@property int16_t length;
@property (retain) OFDataArray *payload;

- (instancetype)initWithChannel:(OFString *)channel payload:(OFDataArray *)data;

@end
