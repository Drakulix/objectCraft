//
//  RaknetHandler.h
//  MinecraftServer
//
//  Created by Victor Brekenfeld on 28.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import <ObjFW/ObjFW.h>

@interface RaknetHandler : OFObject

- (void)didRecieveData:(OFDataArray *)data fromPeer:(of_udp_socket_address_t)address;

@end
