//
//  UDPPacket.h
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 09.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UDPPacket : NSObject

+ (void)setup;
+ (void)addPacketClass:(Class)class forId:(uint8_t)pId;
+ (NSDictionary *)packetList;

+ (UDPPacket *)packetWithId:(uint8_t)pID data:(NSData *)data;
+ (uint8_t)packetId;

- (instancetype)initWithData:(NSData *)data;

- (NSData *)packetData;
- (NSData *)rawPacketData;

@end
