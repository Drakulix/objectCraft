//
//  ConfigManager.m
//  MinecraftServer
//
//  Created by Victor Brekenfeld on 23.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "ConfigManager.h"
#import "RandomGenerator.h"

@implementation ConfigManager

static ConfigManager *sharedInstance;

+ (ConfigManager *)defaultManager {
    if (!sharedInstance)
        return [[self alloc] init];
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        @try {
            settings = [[OFString stringWithContentsOfFile:@"config.json"] JSONValue];
        }
        @catch (OFException *exception) {
            settings = nil;
        }
        if (!settings || ![settings isKindOfClass:[OFDictionary class]]) {
            settings = [[OFDictionary alloc] initWithKeysAndObjects:
                @"tcpIPv4Enabled", [OFNumber numberWithBool:YES],
                @"tcpIPv6Enabled", [OFNumber numberWithBool:YES],
                @"tcpLanBroadcastEnabled", [OFNumber numberWithBool:YES],
                @"tcpIPv4Port", [OFNumber numberWithInt16:25565],
                @"tcpIPv6Port", [OFNumber numberWithInt16:25565],
                @"udpIPv4Enabled", [OFNumber numberWithBool:YES],
                @"udpIPv4Port", [OFNumber numberWithInt16:19132],
                @"udpIPv6Enabled", [OFNumber numberWithBool:YES],
                @"udpIPv6Port", [OFNumber numberWithInt16:19132],
                @"udpLanBroadcastEnabled", [OFNumber numberWithBool:YES],
                @"serverName", @"ObjectCraft Server",
                @"loginWelcomeMessageEnabled", [OFNumber numberWithBool:YES],
                @"loginWelcomeMessage", @"Welcome to our ObjectCraft Server! Have fun ;)",
                @"defaultGamemode", @"SURVIVAL",
                @"isHardcore", [OFNumber numberWithBool:NO],
                @"dimensions", [OFDictionary dictionaryWithKeysAndObjects:
                                [OFNumber numberWithInt8:-1], @"NetherGenerator",
                                [OFNumber numberWithInt8:0], @"OverworldGenerator",
                                [OFNumber numberWithInt8:1], @"EndGenerator",
                                nil],
                @"defaultSpawnDimension", [OFNumber numberWithInt8:0],
                @"defaultSpawnPoint", [OFArray arrayWithObjects:
                                       [OFNumber numberWithInt32:0],
                                       [OFNumber numberWithInt32:0],
                                       nil],
                @"maxPlayers", [OFNumber numberWithInt32:64],
                @"seed", [OFNumber numberWithInt32:[[RandomGenerator globalGenerator] nextRandomInt32]],
                @"udpServerId", [OFNumber numberWithInt64:0],
             nil];
            [[settings JSONRepresentation] writeToFile:@"config.json" encoding:OF_STRING_ENCODING_UTF_8];
        }
        
        sharedInstance = self;
    }
    return self;
}

//Technical Server Settings
- (BOOL)tcpIPv4Enabled {
    return [[settings objectForKey:@"tcpIPv4Enabled"] boolValue];
}
- (int16_t)tcpIPv4Port {
    return [[settings objectForKey:@"tcpIPv4Port"] int16Value];
}

- (BOOL)tcpIPv6Enabled {
    return [[settings objectForKey:@"tcpIPv6Enabled"] boolValue];
}
- (int16_t)tcpIPv6Port {
    return [[settings objectForKey:@"tcpIPv6Port"] int16Value];
}

- (BOOL)tcpLanWorldBroadcastEnabled {
    return [[settings objectForKey:@"tcpLanBroadcastEnabled"] boolValue];
}


- (BOOL)udpIPv4Enabled {
    return [[settings objectForKey:@"udpIPv4Enabled"] boolValue];
}

- (int16_t)udpIPv4Port {
    return [[settings objectForKey:@"udpIPv4Port"] int16Value];
}

- (BOOL)udpIPv6Enabled {
    return [[settings objectForKey:@"udpIPv6Enabled"] boolValue];
}

- (int16_t)udpIPv6Port {
    return [[settings objectForKey:@"udpIPv6Port"] int16Value];
}

- (BOOL)udpLanWorldBroadcastEnabled {
    return [[settings objectForKey:@"udpLanBroadcastEnabled"] boolValue];
}

- (int64_t)udpServerId  //unique Id for every Minecraft PE install,
                        //never use your own, you will probably not be able to connect
{
    return [[settings objectForKey:@"udpServerId"] int64Value];
}


//Game Related Server Settings
- (OFString *)serverBrowserMessage {
    return [settings objectForKey:@"serverName"];
}
- (BOOL)loginWelcomeMessageEnabled {
    return [[settings objectForKey:@"loginWelcomeMessageEnabled"] boolValue];
}
- (OFString *)loginWelcomeMessage {
    return [settings objectForKey:@"loginWelcomeMessage"];
}


//Game Mode
- (uint8_t)defaultGamemode {
    OFString *string = [settings objectForKey:@"defaultGamemode"];
    if ([string isEqual:@"SURVIVAL"]) {
        return 0;
    }
    if ([string isEqual:@"CREATIVE"]) {
        return 1;
    }
    if ([string isEqual:@"ADVENTURE"]) {
        return 2;
    }
    return 0;
}
- (BOOL)isHardcore {
    return [[settings objectForKey:@"isHardcore"] boolValue];
}


//World Settings
- (int8_t)spawnDimension {
    return [[settings objectForKey:@"defaultSpawnDimension"] int8Value];
}
- (NSDictionary *)dimensions {
    return [settings objectForKey:@"dimensions"];
}


//Global World Settings
- (int32_t)seed {
    return [[settings objectForKey:@"seed"] int32Value];
}
- (int32_t)maxPlayers {
    return [[settings objectForKey:@"maxPlayers"] int32Value];
}
- (of_point_t)defaultSpawnPoint {
    return of_point([[[settings objectForKey:@"defaultSpawnPoint"] objectAtIndex:0] int32Value], [[[settings objectForKey:@"defaultSpawnPoint"] objectAtIndex:1] int32Value]);
}

@end
