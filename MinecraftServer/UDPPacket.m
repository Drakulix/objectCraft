//
//  UDPPacket.m
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 09.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "UDPPacket.h"
#import <objc/runtime.h>
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
                while (class != nil) {
                    if (strcmp(class_getName(class_getSuperclass(class)), "UDPPacket") == 0) {
                        [classes[i] methodForSelector:@selector(setup)](classes[i], @selector(setup));
                        break;
                    } else {
                        class = class_getSuperclass(class);
                    }
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
        return (UDPPacket *)[[objc_getClass([[packetList objectForKey:[OFString stringWithFormat:@"%02x", pId]] UTF8String]) alloc] initWithData:data];
    }
    @catch (OFException *exception) {
        return nil;
    }
}

- (instancetype)initWithData:(OFDataArray *)data {
    return [super init];
}

+ (uint8_t)packetId {
    @throw [OFException exception]; //WithName:@"Raw UDPPacket call" reason:[NSString stringWithFormat:@"PacketID must be overriden and called via subclass %@", [self class]] userInfo:nil];
}

- (OFDataArray *)packetData {
    @throw [OFException exception]; //WithName:@"Raw UDPPacket call" reason:[NSString stringWithFormat:@"PacketData must be overriden and called via subclass %@", [self class]] userInfo:nil];
}


- (OFDataArray *)rawPacketData {
    OFDataArray *packetData = [self packetData];
    uint8_t packetId = [[self class] packetId];
    [packetData insertItem:&packetId atIndex:0];
    return packetData;
}

- (OFString *)description {
    return [OFString stringWithFormat:@"%@:\n %@", [super description], [UDPPacket autoDescribe:self classType:[self class]]];
}

// Finds all properties of an object, and prints each one out as part of a string describing the class.
+ (OFString *) autoDescribe:(id)instance classType:(Class)classType
{
    unsigned int count;
    objc_property_t *propList = class_copyPropertyList(classType, &count);
    OFMutableString *propPrint = [OFMutableString string];
    
    for ( int i = 0; i < count; i++ )
    {
        objc_property_t property = propList[i];
        
        const char *propName = property_getName(property);
        OFString *propNameString = [OFString stringWithCString:propName encoding:OF_STRING_ENCODING_ASCII];
        
        if(propName)
        {
            @try {
                id value = [instance valueForKey:propNameString];
                [propPrint appendString:[OFString stringWithFormat:@"\t%@=%@;\n", propNameString, value]];
            }
            @catch (NSException *exception) {
                [propPrint appendString:[OFString stringWithFormat:@"\t%@='Not printable'\n", propNameString]];
            }
        }
    }
    free(propList);
    
    
    // Now see if we need to map any superclasses as well.
    Class superClass = class_getSuperclass( classType );
    if ( superClass != nil && ! [superClass isEqual:[OFObject class]] )
    {
        OFString *superString = [self autoDescribe:instance classType:superClass];
        [propPrint appendString:superString];
    }
    
    return propPrint;
}


@end
