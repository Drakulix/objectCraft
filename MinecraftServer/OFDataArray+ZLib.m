//
//  OFDataArray+ZLib.m
//  MinecraftServer
//
//  Created by Victor Brekenfeld on 04.02.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import <zlib.h>
#import "OFDataArray+ZLib.h"

@implementation OFDataArray (ZLib)

- (OFDataArray *)zlibDeflate
{
    uLongf compLen = compressBound([self count]);
    void *buffer = malloc(compLen);
    if (compress (buffer, &compLen, [self items], [self count]) != Z_OK) {
        free(buffer);
        return nil;
    }
    
    OFDataArray *compressed = [OFDataArray dataArrayWithCapacity:compLen];
    [compressed addItems:buffer count:compLen];
    free(buffer);
    return compressed;
}

- (OFDataArray *)zlibInflate
{
	if ([self count] == 0)
	{
		return self;
	}
	
	z_stream strm;
	strm.zalloc = Z_NULL;
	strm.zfree = Z_NULL;
	strm.opaque = Z_NULL;
	if (Z_OK != inflateInit(&strm))
	{
		[OFInitializationFailedException exception];
	}
	
    size_t bufferSize = [self count]*2.5;
	void *buffer = malloc(bufferSize);
    
	strm.next_out = buffer;
	strm.avail_out = (uint)bufferSize;
	strm.next_in = [self items];
	strm.avail_in = (uint)[self count];
	
	while (inflate(&strm, Z_FINISH) != Z_STREAM_END)
	{
		// inflate should return Z_STREAM_END on the first call
		buffer = realloc(buffer, (bufferSize *= 1.5));
		strm.next_out = buffer + strm.total_out;
		strm.avail_out = (uint)(bufferSize - strm.total_out);
	}
	
	OFDataArray *decompressed = [OFDataArray dataArrayWithCapacity:strm.total_out];
    [decompressed addItems:buffer count:strm.total_out];
    
	inflateEnd(&strm);
	
	return decompressed;
}


@end
