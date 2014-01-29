//
//  UDPMovePlayer.m
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 22.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "UDPMovePlayer.h"

@implementation UDPMovePlayer

- (instancetype)initWithPlayer:(Player *)player {
    return [super initWithEntity:player];
}

- (instancetype)initWithData:(NSData *)data {
    self = [super initWithData:data];
    if (self) {
        //self.unknown = [[[data subdataWithRange:NSMakeRange([data length]-sizeof(float), sizeof(float))] mutableCopy] readFloat];
    }
    return self;
}

+ (uint8_t)packetId {
    return 0x95;
}

- (NSData *)packetData {
    //NSMutableData *packetData = [[super packetData] mutableCopy];
    //[packetData appendFloat:self.unknown];
    //return packetData;
    return nil;
}

@end
