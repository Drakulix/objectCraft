//
//  NSMutableData+StringWriter.m
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 05.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "OFDataArray+StringWriter.h"
#import "OFDataArray+IntWriter.h"
#import "OFDataArray+VarIntWriter.h"
#import <string.h>

@implementation OFDataArray (StringWriter)

- (void)appendStringTcp:(OFString *)string {
    const char* nullString = [string UTF8String];
    size_t lenght = strlen(nullString);
    
    [self appendVarInt:lenght];
    [self addItems:nullString count:lenght];
}

- (void)appendStringUdp:(OFString *)string {
    const char *stringData = [string lossyCStringWithEncoding:OF_STRING_ENCODING_ASCII];
    size_t len = [string cStringLengthWithEncoding:OF_STRING_ENCODING_ASCII];
    [self appendShort:len];
    [self addItems:stringData count:len];
}

@end
