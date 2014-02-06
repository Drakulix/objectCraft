//
//  TCPLoginStart.h
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 05.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import <ObjFW/ObjFW.h>
#import "TCPClientPacket.h"

@interface TCPLoginStart : TCPClientPacket
@property (nonatomic, retain) OFString *username;
@end
