//
//  UDPLoginPacket.h
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 09.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "UDPPacket.h"

@interface UDPLogin : UDPPacket

@property (nonatomic) OFString *username;
@property (nonatomic) int32_t protocol1;
@property (nonatomic) int32_t protocol2;
@property (nonatomic) int32_t clientId;
@property (nonatomic) OFString *realmsData;

@end
