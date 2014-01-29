//
//  ConfigManager.h
//  MinecraftServer
//
//  Created by Victor Brekenfeld on 23.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import <ObjFW/ObjFW.h>
@class WorldGenerator;

@interface ConfigManager : OFObject {
    OFMutableDictionary *settings;
}
+ (ConfigManager *)defaultManager;



//Technical Server Settings
//TCP
@property (nonatomic) BOOL tcpIPv4Enabled;
@property (nonatomic) int16_t tcpIPv4Port;

@property (nonatomic) BOOL tcpIPv6Enabled;
@property (nonatomic) int16_t tcpIPv6Port;

@property (nonatomic) BOOL tcpLanWorldBroadcastEnabled;

//UDP
@property (nonatomic) BOOL udpIPv4Enabled;
@property (nonatomic) int16_t udpIPv4Port;

@property (nonatomic) BOOL udpIPv6Enabled;
@property (nonatomic) int16_t udpIPv6Port;

@property (nonatomic) BOOL udpLanWorldBroadcastEnabled;

@property (nonatomic) int64_t udpServerId; //unique Id for every Minecraft PE install,
                               //never use your own, you will probably not be able to connect



//Game Related Server Settings
@property (nonatomic, retain) OFString *serverBrowserMessage;

@property (nonatomic) BOOL loginWelcomeMessageEnabled;
@property (nonatomic, retain) OFString *loginWelcomeMessage;



//Game Mode
@property (nonatomic) uint8_t defaultGamemode;
@property (nonatomic) BOOL isHardcore;


//World Settings
@property (nonatomic) int8_t spawnDimension;
@property (nonatomic, retain) OFDictionary *dimensions;
- (void)addDimension:(int8_t)dimensionNum withGenerator:(WorldGenerator *)generator;
- (void)removeDimension:(int8_t)dimensionNum;

//Global World Settings
@property (nonatomic) int32_t seed;
@property (nonatomic) int32_t maxPlayers;
@property (nonatomic) of_point_t defaultSpawnPoint;

@end
