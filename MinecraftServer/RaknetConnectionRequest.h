//
//  RaknetConnectionRequest.h
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 08.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import <ObjFW/ObjFW.h>
#import "RaknetPacket.h"

@interface RaknetConnectionRequest : RaknetPacket

@property (nonatomic) int8_t protocolVersion;
@property (nonatomic) uint64_t mtuSize;

@end
