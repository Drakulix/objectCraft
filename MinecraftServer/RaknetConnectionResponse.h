//
//  RaknetConnectionResponse.h
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 08.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import <ObjFW/ObjFW.h>
#import "RaknetPacket.h"

@interface RaknetConnectionResponse : RaknetPacket

@property int64_t serverId;
@property int8_t  serverSecurity;
@property int16_t mtuSize;

- (instancetype)initWithMtuSize:(int16_t)mtuSize;

@end
