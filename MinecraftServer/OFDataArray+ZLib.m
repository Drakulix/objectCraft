//
//  OFDataArray+ZLib.m
//  MinecraftServer
//
//  Created by Victor Brekenfeld on 04.02.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import <zlib.h>
#import "OFDataArray+ZLib.h"

@implementation OFDataArray (ZLib)

- (OFDataArray *)zlibDeflate
{
    uLongf compLen = compressBound([self count]);
    void *buffer = malloc(compLen);
    if (compress (buffer, &compLen, [self items], [self count]) != Z_OK) {
        free(buffer);
        return nil;
    }
    
    OFDataArray *compressed = [[OFDataArray alloc] initWithCapacity:compLen];
    [compressed addItems:buffer count:compLen];
    free(buffer);
    return compressed;
}

@end
