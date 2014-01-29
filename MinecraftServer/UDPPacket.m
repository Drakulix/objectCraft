//
//  UDPPacket.m
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 09.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "UDPPacket.h"
#import <objc/runtime.h>

@implementation UDPPacket
static NSMutableDictionary *packetList;

+ (void)setup {
    if (self == [UDPPacket class]) {
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            packetList = [[NSMutableDictionary alloc] init];
        });
        
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
        @catch (NSException *exception) {}
        
    }
}

+ (void)addPacketClass:(Class)class forId:(uint8_t)pId {
    [packetList setObject:NSStringFromClass(class) forKey:[NSString stringWithFormat:@"%02x", pId]];
}

+ (NSDictionary *)packetList {
    return packetList;
}

+ (UDPPacket *)packetWithId:(uint8_t)pId data:(NSData *)data {
    return (UDPPacket *)[[NSClassFromString([packetList objectForKey:[NSString stringWithFormat:@"%02x", pId]]) alloc] initWithData:data];
}

- (instancetype)initWithData:(NSData *)data {
    return [super init];
}

+ (uint8_t)packetId {
    @throw [NSException exceptionWithName:@"Raw UDPPacket call" reason:[NSString stringWithFormat:@"PacketID must be overriden and called via subclass %@", [self class]] userInfo:nil];
}

- (NSData *)packetData {
    @throw [NSException exceptionWithName:@"Raw UDPPacket call" reason:[NSString stringWithFormat:@"PacketData must be overriden and called via subclass %@", [self class]] userInfo:nil];
}


- (NSData *)rawPacketData {
    NSMutableData *rawPacketData = [[NSMutableData alloc] init];
    NSData *packetData = [self packetData];
    
    [rawPacketData appendByte:[[self class] packetId]];
    [rawPacketData appendData:packetData];
    
    return rawPacketData;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@:\n %@", [super description], [UDPPacket autoDescribe:self classType:[self class]]];
}

// Finds all properties of an object, and prints each one out as part of a string describing the class.
+ (NSString *) autoDescribe:(id)instance classType:(Class)classType
{
    unsigned int count;
    objc_property_t *propList = class_copyPropertyList(classType, &count);
    NSMutableString *propPrint = [NSMutableString string];
    
    for ( int i = 0; i < count; i++ )
    {
        objc_property_t property = propList[i];
        
        const char *propName = property_getName(property);
        NSString *propNameString =[NSString stringWithCString:propName encoding:NSASCIIStringEncoding];
        
        if(propName)
        {
            @try {
                id value = [instance valueForKey:propNameString];
                [propPrint appendString:[NSString stringWithFormat:@"\t%@=%@;\n", propNameString, value]];
            }
            @catch (NSException *exception) {
                [propPrint appendString:[NSString stringWithFormat:@"\t%@='Not printable'\n", propNameString]];
            }
        }
    }
    free(propList);
    
    
    // Now see if we need to map any superclasses as well.
    Class superClass = class_getSuperclass( classType );
    if ( superClass != nil && ! [superClass isEqual:[NSObject class]] )
    {
        NSString *superString = [self autoDescribe:instance classType:superClass];
        [propPrint appendString:superString];
    }
    
    return propPrint;
}


@end
