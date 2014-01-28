//
//  NSMutableData+FloatWriter.h
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 06.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import <ObjFW/ObjFW.h>

@interface OFDataArray (FloatWriter)

- (void)appendFloat:(float)floatVal;
- (void)appendDouble:(double)doubleVal;

@end
