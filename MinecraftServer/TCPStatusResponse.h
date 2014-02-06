//
//  TCPStatusResponse.h
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 10.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "TCPServerPacket.h"

@interface TCPStatusResponse : TCPServerPacket

@property (nonatomic, retain) OFDictionary *json;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
