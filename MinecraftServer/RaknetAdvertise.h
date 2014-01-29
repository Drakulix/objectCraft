//
//  RaknetAdvertise.h
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 08.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import <ObjFW/ObjFW.h>
#import "RaknetPacket.h"

@interface RaknetAdvertise : RaknetPacket

@property (nonatomic) int64_t pingId;
@property (nonatomic) int64_t serverId;
@property (nonatomic, retain) OFString *identifier;

- (instancetype)initWithPingId:(int64_t)pingId withIndetifier:(OFString *)string;

@end
