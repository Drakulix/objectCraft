//
//  WorldManager.h
//  MinecraftServer
//
//  Created by Victor Brekenfeld on 26.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import <ObjFW/ObjFW.h>

@interface WorldManager : OFObject {
    OFMutableDictionary *dimensions;
}

+ (WorldManager *)defaultManager;

@end
