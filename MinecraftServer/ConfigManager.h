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
@property (nonatomic) bool tcpEnabled;
@property (nonatomic) int16_t tcpPort;

@property (nonatomic) bool tcpLanWorldBroadcastEnabled;

//UDP
@property (nonatomic) bool udpEnabled;
@property (nonatomic) int16_t udpPort;

@property (nonatomic) bool udpLanWorldBroadcastEnabled;

@property (nonatomic) int64_t udpServerId; //unique Id for every Minecraft PE install,
                               //never use your own, you will probably not be able to connect



//Game Related Server Settings
@property (nonatomic, retain) OFString *serverBrowserMessage;

@property (nonatomic) bool loginWelcomeMessageEnabled;
@property (nonatomic, retain) OFString *loginWelcomeMessage;



//Game Mode
@property (nonatomic) uint8_t defaultGamemode;
@property (nonatomic) bool isHardcore;


//World Settings
@property (nonatomic) int8_t spawnDimension;
@property (nonatomic, retain) OFDictionary *dimensions;
- (void)addDimension:(int8_t)dimensionNum withGenerator:(WorldGenerator *)generator;
- (void)removeDimension:(int8_t)dimensionNum;

//Global World Settings
@property (nonatomic) int32_t seed;
@property (nonatomic) int32_t maxPlayers;
@property (nonatomic) of_point_t defaultSpawnPoint;
@property (nonatomic) uint8_t difficulty;

@end
