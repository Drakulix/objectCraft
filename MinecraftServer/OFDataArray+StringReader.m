//
//  NSMutableData+StringReader.m
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 05.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "OFDataArray+StringReader.h"
#import "OFDataArray+IntReader.h"
#import "OFDataArray+VarIntReader.h"

@implementation OFDataArray (StringReader)

- (OFString *)readStringTcp {
    uint64_t varLength = [self readVarInt];
    
    OFDataArray *rawString = [[OFDataArray alloc] initWithItemSize:1 capacity:varLength];
    [rawString addItems:[self items] count:varLength];
    [rawString addItem:"\0"];
    const void *bytes = [rawString items];
    OFString *string = [OFString stringWithUTF8String:bytes];
    
    [self removeItemsInRange:of_range(0, varLength)];
    return string;
}

- (OFString *)readStringUdp {
    int16_t stringLength = [self readShort];
    OFString *string = @"";
    if (stringLength > 0) {
        const char* rawAsciiString = [self items];
        string = [OFString stringWithCString:rawAsciiString encoding:OF_STRING_ENCODING_ASCII];
        [self removeItemsInRange:of_range(0, stringLength)];
    }
    return string;
}

@end
