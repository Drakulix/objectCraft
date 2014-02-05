//
//  TCPLoginSuccess.h
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 05.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import <ObjFW/ObjFW.h>
#import "TCPServerPacket.h"

@interface TCPLoginSuccess : TCPServerPacket

@property (retain) OFString *uuid;
@property (retain) OFString *username;

- (instancetype)initWithUUID:(OFString *)uuid Username:(OFString *)username;

@end
