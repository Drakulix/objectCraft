//
//  NSMutableData+FloatReader.h
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 07.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import <ObjFW/ObjFW.h>

@interface OFDataArray (FloatReader)

- (float)readFloat;
- (double)readDouble;

@end
