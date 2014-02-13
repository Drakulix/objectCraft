//
//  RaknetACK.m
//  
//
//  Created by Victor Brekenfeld on 09.01.14.
//
//

#import "RaknetACK.h"
#import "OFDataArray+IntReader.h"
#import "OFDataArray+IntWriter.h"

@implementation RaknetACK
@dynamic packetNumber, additionalPacketNumber;
@synthesize unknown, hasAdditionalPacketNumber;

- (instancetype)initWithPacketNumber:(uint32_t)_packetNumber {
    self = [super init];
    @try {
        self.unknown = 1;
        packetNumber.i = _packetNumber;
        self.hasAdditionalPacketNumber = false;
        
    } @catch (id e) {
        [self release];
        @throw e;
    }
    return self;
}

- (instancetype)initWithData:(OFDataArray *)data {
    self = [super init];
    @try {
        self.unknown = [data readShort];
        self.hasAdditionalPacketNumber = [data readBoolUdp];
        packetNumber = [data readUInt24];
        if (self.hasAdditionalPacketNumber) {
            additionalPacketNumber = [data readUInt24];
        }
    } @catch (id e) {
        [self release];
        @throw e;
    }
    return self;
}

+ (uint8_t)packetId {
    return 0xc0;
}

- (OFDataArray *)packetData {
    OFDataArray *packetData = [OFDataArray dataArray];
    [packetData appendShort:self.unknown];
    [packetData appendBoolUdp:self.hasAdditionalPacketNumber];
    [packetData appendUInt24:packetNumber];
    if (self.hasAdditionalPacketNumber) {
        [packetData appendUInt24:additionalPacketNumber];
    }
    return packetData;
}

- (uint32_t)packetNumber {
    return packetNumber.i;
}

- (uint32_t)additionalPacketNumber {
    return additionalPacketNumber.i;
}

- (void)setPacketNumber:(uint32_t)_packetNumber {
    if (_packetNumber > INT24_MAX) {
        _packetNumber -= INT24_MAX;
    }
    packetNumber.i = _packetNumber;
}

- (void)setAdditionalPacketNumber:(uint32_t)_additionalPacketNumber {
    if (_additionalPacketNumber > INT24_MAX) {
        _additionalPacketNumber -= INT24_MAX;
    }
    additionalPacketNumber.i = _additionalPacketNumber;
}

@end
