//
//  NSMutableData+StringWriter.h
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 05.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import <ObjFW/ObjFW.h>

@interface OFDataArray (StringWriter)

- (void)appendStringTcp:(OFString *)string;
- (void)appendStringUdp:(OFString *)string;

@end
