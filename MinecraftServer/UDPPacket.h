//
//  UDPPacket.h
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 09.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import <ObjFW/ObjFW.h>

@interface UDPPacket : OFObject

+ (void)setup;
+ (void)addPacketClass:(Class)class forId:(uint8_t)pId;

+ (UDPPacket *)packetWithId:(uint8_t)pID data:(OFDataArray *)data;
+ (uint8_t)packetId;

- (instancetype)initWithData:(OFDataArray *)data;

- (OFDataArray *)packetData;
- (OFDataArray *)rawPacketData;

@end
