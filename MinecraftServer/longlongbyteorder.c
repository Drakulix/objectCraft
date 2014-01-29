//
//  longlongbyteorder.cpp
//  Minecraft Server
//
//  Created by Victor Brekenfeld on 14.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#include "longlongbyteorder.h"
#include <arpa/inet.h>

int64_t htonll(int64_t vv) {
#ifdef OF_BIG_ENDIAN
    return vv;
#else
    return (((uint64_t)htonl(vv)) << 32) + htonl(vv >> 32);
#endif
}

int64_t ntohll(int64_t vv) {
#ifdef OF_BIG_ENDIAN
    return vv;
#else
    return (((uint64_t)ntohl(vv)) << 32) + ntohl(vv >> 32);
#endif
}