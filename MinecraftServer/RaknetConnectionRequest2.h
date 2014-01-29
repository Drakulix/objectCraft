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

@property (nonatomic) int8_t clientSecurity;
@property (nonatomic) int32_t cookie;
@property (nonatomic) int16_t serverUDPPort;
@property (nonatomic) uint8_t mtuSize;
@property (nonatomic) int64_t clientId;

@end
