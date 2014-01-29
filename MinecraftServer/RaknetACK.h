//
//  RaknetACK.h
//  
//
//  Created by Victor Brekenfeld on 09.01.14.
//
//

#import <ObjFW/ObjFW.h>
#import "RaknetPacket.h"
#import "int24_t.h"

@interface RaknetACK : RaknetPacket {
    uint24_t packetNumber;
    uint24_t additionalPacketNumber;
}

@property (nonatomic) int16_t unknown;
@property (nonatomic) BOOL hasAdditionalPacketNumber;
@property (nonatomic) uint32_t packetNumber;
@property (nonatomic) uint32_t additionalPacketNumber;

- (instancetype)initWithPacketNumber:(uint32_t)packetNumber;

@end
