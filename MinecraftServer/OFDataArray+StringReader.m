//
//  NSMutableData+StringReader.m
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 05.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "OFDataArray+StringReader.h"
#import "OFDataArray+IntReader.h"

@implementation OFDataArray (StringReader)

- (OFString *)readStringTcp {
    uint64_t varLength = [self readVarInt];
    NSMutableData *rawString = [[self subdataWithRange:NSMakeRange(0, varLength)] mutableCopy];
    [rawString appendBytes:"\0" length:sizeof("\0")];
    const void *bytes = [rawString  bytes];
    NSString *string = [NSString stringWithUTF8String:bytes];
    [self replaceBytesInRange:NSMakeRange(0, varLength) withBytes:NULL length:0];
    return string;
}

- (OFString *)readStringUdp {
    int16_t stringLength = [self readShort];
    OFString *string = @"";
    if (stringLength > 0) {
        const char* rawAsciiString = [self firstItem];
        string = [NSString stringWithCString:rawAsciiString encoding:NSASCIIStringEncoding];
        [self removeItemsInRange:of_range(0, stringLength)]
    }
    return string;
}

@end
