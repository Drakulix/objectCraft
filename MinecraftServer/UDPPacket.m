//
//  UDPPacket.m
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 09.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "UDPPacket.h"
#import <string.h>

@implementation UDPPacket
static OFMutableDictionary *packetList;

+ (void)setup {
    if (self == [UDPPacket class]) {
        
        packetList = [[OFMutableDictionary alloc] init];
        
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
                if (strcmp(class_getName(class), "Object") != 0 && [class isKindOfClass:[UDPPacket class]]) {
                    [class setup];
                }
            }
            
            free(classes);
        }
        
    } else {
        
        @try {
            [UDPPacket addPacketClass:self forId:[self packetId]];
        }
        @catch (OFException *exception) {}
        
    }
}

+ (void)addPacketClass:(Class)class forId:(uint8_t)pId {
    [packetList setObject:[class description] forKey:[OFString stringWithFormat:@"%02x", pId]];
}

+ (OFDictionary *)packetList {
    return packetList;
}

+ (UDPPacket *)packetWithId:(uint8_t)pId data:(OFDataArray *)data {
    @try {
        return [(UDPPacket *)[[objc_getClass([[packetList objectForKey:[OFString stringWithFormat:@"%02x", pId]] UTF8String]) alloc] initWithData:data] autorelease];
    }
    @catch (OFException *exception) {
        return nil;
    }
}

- (instancetype)initWithData:(OFDataArray *)data {
    return [super init];
}

+ (uint8_t)packetId {
    @throw [OFNotImplementedException exception]; //WithName:@"Raw UDPPacket call" reason:[NSString stringWithFormat:@"PacketID must be overriden and called via subclass %@", [self class]] userInfo:nil];
}

- (OFDataArray *)packetData {
    @throw [OFNotImplementedException exception]; //WithName:@"Raw UDPPacket call" reason:[NSString stringWithFormat:@"PacketData must be overriden and called via subclass %@", [self class]] userInfo:nil];
}


- (OFDataArray *)rawPacketData {
    OFDataArray *packetData = [[self packetData] retain];
    uint8_t packetId = [[self class] packetId];
    [packetData insertItem:&packetId atIndex:0];
    return [packetData autorelease];
}

@end
