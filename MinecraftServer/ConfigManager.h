//
//  ConfigManager.h
//  MinecraftServer
//
//  Created by Victor Brekenfeld on 23.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import <ObjFW/ObjFW.h>

@interface ConfigManager : OFObject {
    OFDictionary *settings;
}
+ (ConfigManager *)sharedInstance;

//Technical Server Settings
- (BOOL)tcpIPv4Enabled;
- (int16_t)tcpIPv4Port;

- (BOOL)tcpIPv6Enabled;
- (int16_t)tcpIPv6Port;

- (BOOL)tcpLanWorldBroadcastEnabled;

- (BOOL)udpEnabled;
- (int16_t)udpPort;

- (BOOL)udpLanWorldBroadcastEnabled;

- (int64_t)udpServerId; //unique Id for every Minecraft PE install,
                        //never use your own, you will probably not be able to connect


//Game Related Server Settings
- (OFString *)serverBrowserMessage;
- (BOOL)loginWelcomeMessageEnabled;
- (OFString *)loginWelcomeMessage;


//Game Mode
- (uint8_t)defaultGamemode;
- (BOOL)isHardcore;


//World Settings
- (int8_t)spawnDimension;
- (NSDictionary *)dimensions;


//Global World Settings
- (int32_t)seed;
- (int32_t)maxPlayers;
- (of_point_t)defaultSpawnPoint;

@end
