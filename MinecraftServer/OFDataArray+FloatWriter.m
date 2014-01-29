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
    float floatSwap = OF_BSWAP_FLOAT_IF_LE(floatVal);
    [self addItems:&floatSwap count:sizeof(float)];
}

- (void)appendDouble:(double)doubleVal {
    double doubleSwap = OF_BSWAP_DOUBLE_IF_LE(doubleVal);
    [self addItems:&doubleSwap count:sizeof(double)];
}

@end
