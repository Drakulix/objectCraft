//
//  RaknetIncompatibleProtocol.h
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 09.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import <ObjFW/ObjFW.h>
#import "RaknetPacket.h"

@interface RaknetIncompatibleProtocol : RaknetPacket

@property int8_t protocolVersion;
@property int64_t serverId;

@end
