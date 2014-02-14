//
//  TCPPacket.h
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 05.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import <ObjFW/ObjFW.h>

@interface TCPPacket : OFObject

+ (int)state;
+ (uint64_t)packetId;

@end
