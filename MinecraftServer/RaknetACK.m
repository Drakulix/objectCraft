//
//  RaknetACK.m
//  
//
//  Created by Victor Brekenfeld on 09.01.14.
//
//

#import "RaknetACK.h"

@implementation RaknetACK
@dynamic packetNumber, additionalPacketNumber;

- (instancetype)initWithPacketNumber:(uint32_t)_packetNumber {
    self = [super init];
    if (self) {
        self.unknown = 1;
        packetNumber.i = _packetNumber;
        self.hasAdditionalPacketNumber = FALSE;
    }
    return self;
}

- (instancetype)initWithData:(NSData *)data {
    self = [super init];
    if (self) {
        NSMutableData *packetData = [data mutableCopy];
        self.unknown = [packetData readShort];
        self.hasAdditionalPacketNumber = [packetData readBoolUdp];
        packetNumber = [packetData readUInt24];
        if (self.hasAdditionalPacketNumber) {
            additionalPacketNumber = [packetData readUInt24];
        }
    }
    return self;
}

+ (uint8_t)packetId {
    return 0xc0;
}

- (NSData *)packetData {
    NSMutableData *packetData = [[NSMutableData alloc] init];
    
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
