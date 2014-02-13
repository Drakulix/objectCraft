//
//  FileManager.h
//  MinecraftServer
//
//  Created by Victor Brekenfeld on 12.02.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import <ObjFW/ObjFW.h>
@class AdvancedFile;

@interface FileManager : OFObject

+ (FileManager *)defaultManager;

- (OFString *)globalConfigFilePath;
- (OFString *)worldConfigFilePathForDimension:(int)dimension;

- (AdvancedFile *)newTmpFile;
- (void)closeTmpFile:(AdvancedFile *)file;

@end
