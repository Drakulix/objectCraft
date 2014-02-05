//
//  OFString+DataUsingEncoding.m
//  MinecraftServer
//
//  Created by Victor Brekenfeld on 04.02.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "OFString+DataUsingEncoding.h"

@implementation OFString (DataUsingEncoding)

- (OFDataArray *)dataUsingEncoding:(of_string_encoding_t)encoding {
    size_t len = [self cStringLengthWithEncoding:encoding];
    const char *str = [self cStringWithEncoding:encoding];
    
    OFDataArray *data = [[OFDataArray alloc] initWithCapacity:len];
    [data addItems:str count:len];
    return data;
}

@end
