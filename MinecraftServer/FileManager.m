//
//  FileManager.m
//  MinecraftServer
//
//  Created by Victor Brekenfeld on 12.02.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "ConfigManager.h"
#import "FileManager.h"
#import "AdvancedFile.h"

static FileManager *sharedInstance;
static OFMutableArray *tmpFileArray;

@implementation FileManager

+ (FileManager *)defaultManager {
    if (!sharedInstance)
        return [[self alloc] init];
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    
    @try {
        if (!tmpFileArray)
            tmpFileArray = [[OFMutableArray alloc] init];
        if (![AdvancedFile directoryExistsAtPath:@"worlds/tmp"]) {
            [AdvancedFile createDirectoryAtPath:@"worlds/tmp" createParents:true];
        }
    }
    @catch (id e) {
        [self release];
        @throw e;
    }
    
    return self;
}

- (OFString *)globalConfigFilePath {
    return @"config.json";
}

- (OFString *)worldConfigFilePathForDimension:(int)dimension {
    return [OFString stringWithFormat:@"worlds/%d/world.conf", dimension];
}

- (AdvancedFile *)newTmpFile {
    AdvancedFile *newTmpFile;
    
    size_t firstNullIndex = [tmpFileArray indexOfObjectIdenticalTo:[OFNull null]];
    if (firstNullIndex != OF_NOT_FOUND) {
        newTmpFile = [AdvancedFile fileWithPath:[OFString stringWithFormat:@"worlds/tmp/%d", firstNullIndex] mode:@"a+b"];
        [tmpFileArray replaceObjectAtIndex:firstNullIndex withObject:newTmpFile];
    } else {
        newTmpFile = [AdvancedFile fileWithPath:[OFString stringWithFormat:@"worlds/tmp/%d", [tmpFileArray count]] mode:@"a+b"];
        [tmpFileArray addObject:newTmpFile];
    }
    
    return newTmpFile;
}

- (void)closeTmpFile:(AdvancedFile *)file {
    [file close];
    size_t index = [tmpFileArray indexOfObject:file];
    [AdvancedFile removeItemAtPath:[OFString stringWithFormat:@"worlds/tmp/%d", index]];
    [tmpFileArray replaceObjectAtIndex:index withObject:[OFNull null]];
}

@end
