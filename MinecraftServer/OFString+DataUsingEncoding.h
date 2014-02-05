//
//  OFString+DataUsingEncoding.h
//  MinecraftServer
//
//  Created by Victor Brekenfeld on 04.02.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import <ObjFW/ObjFW.h>

@interface OFString (DataUsingEncoding)

- (OFDataArray *)dataUsingEncoding:(of_string_encoding_t)encoding;

@end
