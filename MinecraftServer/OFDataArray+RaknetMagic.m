//
//  NSMutableData+RaknetMagic.m
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 08.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "OFDataArray+RaknetMagic.h"
#import "OFDataArray+IntReader.h"
#import "OFDataArray+IntWriter.h"

@implementation OFDataArray (RaknetMagic)

const int64_t magic1 = 0x00ffff00fefefefe;
const int64_t magic2 = 0xfdfdfdfd12345678;

- (BOOL)checkMagic {
    if ([self readLong] != magic1) {
        return FALSE;
    }
    if ([self readLong] != magic2) {
        return FALSE;
    }
    return TRUE;
}

- (void)appendMagic {
    [self appendLong:magic1];
    [self appendLong:magic2];
}

@end
