//
//  RaknetMinecraftPacket.m
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 09.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "RaknetMinecraftPacket.h"
#import "RaknetHandler.h"
#import <objc/runtime.h>

#import "OFDataArray+IntReader.h"
#import "OFDataArray+IntWriter.h"

@implementation RaknetMinecraftPacket
@dynamic count, orderId;

+ (RaknetMinecraftPacket *)readPacketFromData:(OFDataArray *)data {
    RaknetMinecraftPacket *minecraftPacket = [[RaknetMinecraftPacket alloc] init];
    
    uint8_t encapsulationId = [data readByte];
    uint8_t reliability = ((encapsulationId & 0xe0) >> 5);
    minecraftPacket.isReliable = (reliability == 2) || (reliability == 3) || (reliability == 4) || (reliability == 6) || (reliability == 7);
    minecraftPacket.isOrdered = (reliability == 1) || (reliability == 3) || (reliability == 4) || (reliability == 7);
    minecraftPacket.isSplit = ((encapsulationId & 0x10) >> 4) == 1;
    
    uint16_t size = [data readShort];
    //assert((size % 8) == 0);
    minecraftPacket.dataLength = size/8;
    
    
    if (minecraftPacket.isReliable) {
        [minecraftPacket setCount24:[data readReverseUInt24]];
        //minecraftPacket.dataLength -= 3;
    }
    
    if (minecraftPacket.isOrdered) {
        [minecraftPacket setOrderId24:[data readReverseUInt24]];
        minecraftPacket.orderChannel = [data readByte];
        //minecraftPacket.dataLength -= 4;
    }
    
    if (minecraftPacket.isSplit) {
        minecraftPacket.splitCount = [data readInt];
        minecraftPacket.splitId = [data readShort];
        minecraftPacket.splitIndex = [data readInt];
        //minecraftPacket.dataLength -= 10;
    }
    
    minecraftPacket.packet = [[OFDataArray alloc] initWithItemSize:1 capacity:minecraftPacket.dataLength];
    [minecraftPacket.packet addItems:[data firstItem] count:minecraftPacket.dataLength];
    [data removeItemsInRange:of_range(0, minecraftPacket.dataLength)];
    return minecraftPacket;
}

- (instancetype)initWithData:(OFDataArray *)data {
    self = [super init];
    if (self) {
        
        self.isReliable = NO;
        
        self.dataLength = ((uint16_t)[data count]);
        self.packet = data;
    }
    return self;
}

- (instancetype)initReliableWithData:(OFDataArray *)data count:(uint24_t)_count {
    self = [super init];
    if (self) {
        
        self.isReliable = YES;
        count = _count;
        
        self.dataLength = ((uint16_t)[data count]);
        self.packet = data;
    }
    return self;
}

- (instancetype)initSplitPacketWithData:(OFDataArray *)data count:(uint24_t)_count splitCount:(int32_t)splitCount splitId:(int16_t)splitId splitIndex:(int32_t)splitIndex {
    self = [super init];
    if (self) {
        
        self.isReliable = YES;
        count = _count;
        
        self.isSplit = YES;
        self.splitCount = splitCount;
        self.splitId = splitId;
        self.splitIndex = splitIndex;
        
        self.dataLength = ((uint16_t)[data count]);
        self.packet = data;
    }
    return self;
}

- (OFDataArray *)packetData {
    OFDataArray *packetData = [[OFDataArray alloc] init];
    
    //TO-DO add real bit writing, but we just use reliable and split packets for now anyway
    
    uint8_t encapsulationId = 0x40;
    if (self.isSplit) {
        encapsulationId = 0x50;
    }
    
    [packetData appendByte:encapsulationId];
    [packetData appendShort:self.dataLength*8];
    [packetData appendReverseUInt24:count];
    
    if (encapsulationId == 0x50) {
        [packetData appendInt:self.splitCount];
        [packetData appendShort:self.splitId];
        [packetData appendInt:self.splitIndex];
    }
    [packetData addItems:[self.packet firstItem] count:[self.packet count]];
    
    return packetData;
}

- (OFString *)description {
    return [OFString stringWithFormat:@"%@: %@", [super description], [RaknetMinecraftPacket autoDescribe:self classType:[self class]]];
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
        OFString *propNameString =[OFString stringWithCString:propName encoding:OF_STRING_ENCODING_ASCII];
        
        if(propName && ![propNameString isEqual:@"packet"])
        {
            @try {
                id value = [instance valueForKey:propNameString];
                [propPrint appendString:[NSString stringWithFormat:@"\t%@=%@;\n", propNameString, value]];
            }
            @catch (OFException *exception) {
                [propPrint appendString:[NSString stringWithFormat:@"\t%@='Not printable'\n", propNameString]];
            }
        }
    }
    free(propList);
    
    
    // Now see if we need to map any superclasses as well.
    Class superClass = class_getSuperclass( classType );
    if ( superClass != nil && ! [superClass isEqual:[OFObject class]] )
    {
        NSString *superString = [self autoDescribe:instance classType:superClass];
        [propPrint appendString:superString];
    }
    
    return propPrint;
}

- (uint32_t)count {
    return count.i;
}
- (void)setCount:(uint32_t)_count {
    if (_count > INT24_MAX) {
        _count -= INT24_MAX;
    }
    count.i = _count;
}

- (void)setCount24:(uint24_t)_count {
    count = _count;
}

- (uint32_t)orderId {
    return orderId.i;
}
- (void)setOrderId:(uint32_t)_orderId {
    if (_orderId > INT24_MAX) {
        _orderId -= INT24_MAX;
    }
    orderId.i = _orderId;
}

- (void)setOrderId24:(uint24_t)_orderId {
    orderId = _orderId;
}

@end
