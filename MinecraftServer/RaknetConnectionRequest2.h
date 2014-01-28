//
//  RaknetConnectionRequest2.h
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 09.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import <ObjFW/ObjFW.h>
#import "RaknetPacket.h"

@interface RaknetConnectionRequest2 : RaknetPacket

@property int8_t clientSecurity;
@property int32_t cookie;
@property int16_t serverUDPPort;
@property uint8_t mtuSize;
@property int64_t clientId;

@end
