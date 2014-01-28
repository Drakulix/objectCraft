//
//  NSMutableData+FloatWriter.m
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 06.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "OFDataArray+FloatWriter.h"

@implementation OFDataArray (FloatWriter)

- (void)appendFloat:(float)floatVal {
    int32_t floatByte = htonl((*((int32_t *)&floatVal)));
    [self addItems:&floatByte count:sizeof(int32_t)];
}

- (void)appendDouble:(double)doubleVal {
    int64_t doubleByte = htonll((*((int64_t *)&doubleVal)));
    [self addItems:&doubleByte count:sizeof(int64_t)];
}

@end
