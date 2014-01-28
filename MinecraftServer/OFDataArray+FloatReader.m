//
//  NSMutableData+FloatReader.m
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 07.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "OFDataArray+FloatReader.h"
#import "OFDataArray+IntReader.h"
#import "longlongbyteorder.h"

@implementation OFDataArray (FloatReader)

- (float)readFloat {
    int32_t floatBits = *(int32_t*)[self readInt];
    floatBits = ntohl(floatBits);
    float floatVal = *((float *)&floatBits);
    return floatVal;
}

- (double)readDouble {
    int64_t intVal = ntohll(*(int64_t *)[self readLong]);
    return *(double *)(&intVal);
}

@end
