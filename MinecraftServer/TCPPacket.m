//
//  TCPPacket.m
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 05.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "TCPPacket.h"
#import "TCPClientPacket.h"
#import "TCPServerPacket.h"
#import <string.h>

@implementation TCPPacket

+ (void)setup {
    if (self == [TCPPacket class]) {
        
        int numClasses;
        Class * classes = NULL;
        
        classes = NULL;
        numClasses = objc_getClassList(NULL, 0);
        
        if (numClasses > 0 )
        {
            classes = (__unsafe_unretained Class *)malloc(sizeof(Class) * numClasses);
            numClasses = objc_getClassList(classes, numClasses);
            
            for (int i = 0; i<numClasses; i++) {
                Class class = classes[i];
                if (strcmp(class_getName(class), "Object") != 0 && [class isKindOfClass:[TCPPacket class]]) {
                    [class setup];
                }
            }
            
            free(classes);
        }
        
    }
}

- (instancetype)initWithData:(OFDataArray *)data {
    return [super init];
}

+ (int)state {
    return 3; //most packets belong to the 'Play' state
}

+ (uint64_t)packetId {
    @throw [OFNotImplementedException exception]; //WithName:@"Raw TCPPacket call" reason:[NSString stringWithFormat:@"PacketID must be overriden and called via subclass %@", [self class]] userInfo:nil];
}

@end
