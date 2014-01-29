//
//  UDPChunkRequest.h
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 22.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "UDPPacket.h"

@interface UDPChunkRequest : UDPPacket

@property (nonatomic) int32_t X;
@property (nonatomic) int32_t Z;

- (instancetype)initForX:(int32_t)x Z:(int32_t)z;

@end
