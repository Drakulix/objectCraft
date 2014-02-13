//
//  AdvancedFile.m
//  MinecraftServer
//
//  Created by Victor Brekenfeld on 12.02.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "AdvancedFile.h"
#import <limits.h>
#include <unistd.h>

static long maxFileCount;
static long currentCount;
static AdvancedFile *firstFile = nil;
static AdvancedFile *lastFile = nil;

@implementation AdvancedFile

+ (void)initialize {
    currentCount = 0;
    maxFileCount = sysconf(_SC_OPEN_MAX);
    of_log(@"max files = %d", maxFileCount);
}

+ (AdvancedFile *)fileWithPath:(OFString *)path mode:(OFString *)mode {
    return [[[AdvancedFile alloc] initWithPath:path mode:mode] autorelease];
}

- (instancetype)initWithPath:(OFString *)path mode:(OFString *)_mode {
    self = [super init];
    
    @try {
        filePath = [path retain];
        mode = [_mode retain];
        file = nil;
        nextFile = nil;
        offset = 0;
    }
    @catch (id e) {
        [self release];
        @throw e;
    }
    
    return self;
}

- (void)dealloc {
    
    if (self == firstFile)
        firstFile = nextFile;
    if (self == lastFile)
        lastFile = preFile;
    if (preFile) {
        [preFile setNextFile:nil];
    }
    if (nextFile) {
        [nextFile setPreFile:nil];
    }
    
    if (file) {
        [file close];
        currentCount--;
    }
    
    [filePath release];
    [mode release];
    [file release];
    [super dealloc];
}

- (OFString *)filePath {
    return filePath;
}


+ (id)forwardingTargetForSelector:(SEL)selector {
    return [OFFile class];
}

- (id)forwardingTargetForSelector:(SEL)selector {
    
    if (!file) {
        
        if (!firstFile) {
            
            firstFile = self;
            nextFile = self;
            
        } else {
            
            currentCount++;
            [lastFile setNextFile:self];
            preFile = lastFile;
            lastFile = self;
            
            if (currentCount == maxFileCount) {
                AdvancedFile *next = [firstFile nextFile];
                [firstFile invalidate];
                firstFile = next;
            }
            
        }
        
        file = [[OFFile alloc] initWithPath:filePath mode:mode];
        [file seekToOffset:offset whence:SEEK_SET];
        
    }
    
    return file;
}

- (void)invalidate {
    
    offset = [file seekToOffset: 0 whence:SEEK_CUR];
    [file close];
    [file release];
    file = nil;
    [nextFile setPreFile:nil];
    nextFile = nil;
    currentCount--;
    
}

- (void)setNextFile:(AdvancedFile *)newFile {
    nextFile = newFile;
}
- (AdvancedFile *)nextFile {
    return nextFile;
}
- (void)setPreFile:(AdvancedFile *)newFile {
    preFile = newFile;
}
- (AdvancedFile *)preFile {
    return preFile;
}

@end
