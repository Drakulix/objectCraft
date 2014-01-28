//
//  RaknetPacket.h
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 08.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import <ObjFW/ObjFW.h>

@interface RaknetPacket : OFObject

+ (void)setup;

+ (RaknetPacket *)packetWithId:(uint8_t)pId data:(OFDataArray *)data;
+ (void)addPacketClass:(Class)class forId:(uint8_t)pId;
+ (uint8_t)packetId;

- (instancetype)initWithData:(OFDataArray *)data;
- (OFDataArray *)packetData;
- (OFDataArray *)rawPacketData;

@end
