//
//  Block.h
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 06.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import <ObjFW/ObjFW.h>

@interface Block : OFObject

- (uint8_t)tcpBlockId;
- (uint8_t)tcpBlockAdd;
- (uint8_t)tcpMetadata;
- (uint8_t)tcpLightEmit;
- (uint8_t)tcpSkyLight;

- (uint8_t)udpBlockId;
- (uint8_t)udpMetadata;

@end
