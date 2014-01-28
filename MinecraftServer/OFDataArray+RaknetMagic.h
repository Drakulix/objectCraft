//
//  NSMutableData+RaknetMagic.h
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 08.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import <ObjFW/ObjFW.h>

@interface OFDataArray (RaknetMagic)

- (BOOL)checkMagic;
- (void)appendMagic;

@end
