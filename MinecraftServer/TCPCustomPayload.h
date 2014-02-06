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

@property (nonatomic, retain) OFString *channel;
@property (nonatomic) int16_t length;
@property (nonatomic, retain) OFDataArray *payload;

- (instancetype)initWithChannel:(OFString *)channel payload:(OFDataArray *)data;

@end
