//
//  main.m
//  MinecraftServer
//
//  Created by Victor Brekenfeld on 22.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import <ObjFW/ObjFW.h>
#import "MinecraftServer.h"

int main(int argc, char * argv[])
{
    OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
    return of_application_main(&argc, &argv, [MinecraftServer class]);
    [pool drain];
}