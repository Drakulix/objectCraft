//
//  ConfigManager.m
//  MinecraftServer
//
//  Created by Victor Brekenfeld on 23.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#import "ConfigManager.h"
#import "RandomGenerator.h"
#import "WorldGenerator.h"
#import "FileManager.h"

@implementation ConfigManager
@dynamic tcpEnabled, tcpPort, tcpLanWorldBroadcastEnabled;
@dynamic udpEnabled, udpPort, udpLanWorldBroadcastEnabled, udpServerId;
@dynamic serverBrowserMessage, loginWelcomeMessageEnabled, loginWelcomeMessage;
@dynamic defaultGamemode, isHardcore;
@dynamic spawnDimension, dimensions;
@dynamic seed, maxPlayers, defaultSpawnPoint, difficulty;

static ConfigManager *sharedInstance;

+ (ConfigManager *)defaultManager {
    if (!sharedInstance)
        return [[self alloc] init];
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    
    @try {
            
        @try {
            @autoreleasepool {
                settings = [[[OFString stringWithContentsOfFile:[[FileManager defaultManager] globalConfigFilePath]] JSONValue] mutableCopy];
            }
        }
        @catch (OFException *exception) {
            settings = nil;
        }
        @autoreleasepool {
            if (!settings || ![settings isKindOfClass:[OFDictionary class]]) {
                settings = [[OFMutableDictionary alloc] initWithKeysAndObjects:
                    @"tcpEnabled", [OFNumber numberWithBool:false],
                    @"tcpPort", [OFNumber numberWithInt16:25565],
                    @"tcpLanWorldBroadcastEnabled", [OFNumber numberWithBool:false],
                    @"udpEnabled", [OFNumber numberWithBool:false],
                    @"udpPort", [OFNumber numberWithInt16:19132],
                    @"udpLanWorldBroadcastEnabled", [OFNumber numberWithBool:false],
                    @"serverBrowserMessage", @"ObjectCraft Server",
                    @"loginWelcomeMessageEnabled", [OFNumber numberWithBool:false],
                    @"loginWelcomeMessage", @"Welcome to our ObjectCraft Server! Have fun ;)",
                    @"defaultGamemode", @"SURVIVAL",
                    @"isHardcore", [OFNumber numberWithBool:false],
                    @"dimensions", [OFDictionary dictionaryWithKeysAndObjects:
                                    @"-1", @"NetherGenerator",
                                    @"0", @"OverworldGenerator",
                                    @"1", @"EndGenerator",
                                    nil],
                    @"defaultSpawnDimension", [OFNumber numberWithInt8:0],
                    @"defaultSpawnPoint", [OFArray arrayWithObjects:
                                           [OFNumber numberWithInt32:0],
                                           [OFNumber numberWithInt32:0],
                                           nil],
                    @"maxPlayers", [OFNumber numberWithInt32:64],
                    @"seed", [OFNumber numberWithInt32:[[RandomGenerator globalGenerator] nextRandomInt32]],
                    @"difficulty", @"NORMAL",
                    @"udpServerId", [OFNumber numberWithInt64:0],
                 nil];
                [[settings JSONRepresentationWithOptions:OF_JSON_REPRESENTATION_PRETTY] writeToFile:[[FileManager defaultManager] globalConfigFilePath] encoding:OF_STRING_ENCODING_UTF_8];
            }
        }
        
    } @catch (id e) {
        [self release];
        @throw e;
    }

    sharedInstance = self;
    return self;
}

- (void)dealloc {
    [settings release];
    [super dealloc];
}

//Technical Server Settings
- (bool)tcpEnabled {
    return [[settings objectForKey:@"tcpEnabled"] boolValue];
}
- (void)setTcpEnabled:(bool)tcpIPv4Enabled {
    @autoreleasepool {
        [settings setObject:[OFNumber numberWithBool:tcpEnabled] forKey:@"tcpEnabled"];
        [[settings JSONRepresentationWithOptions:OF_JSON_REPRESENTATION_PRETTY] writeToFile:[[FileManager defaultManager] globalConfigFilePath] encoding:OF_STRING_ENCODING_UTF_8];
    }
}

- (int16_t)tcpPort {
    return [[settings objectForKey:@"tcpPort"] int16Value];
}
- (void)setTcpPort:(int16_t)tcpPort {
    @autoreleasepool {
        [settings setObject:[OFNumber numberWithInt16:tcpPort] forKey:@"tcpPort"];
        [[settings JSONRepresentationWithOptions:OF_JSON_REPRESENTATION_PRETTY] writeToFile:[[FileManager defaultManager] globalConfigFilePath] encoding:OF_STRING_ENCODING_UTF_8];
    }
}

- (bool)tcpLanWorldBroadcastEnabled {
    return [[settings objectForKey:@"tcpLanBroadcastEnabled"] boolValue];
}
- (void)setTcpLanWorldBroadcastEnabled:(bool)tcpLanWorldBroadcastEnabled {
    @autoreleasepool {
        [settings setObject:[OFNumber numberWithBool:tcpLanWorldBroadcastEnabled] forKey:@"tcpLanWorldBroadcastEnabled"];
        [[settings JSONRepresentationWithOptions:OF_JSON_REPRESENTATION_PRETTY] writeToFile:[[FileManager defaultManager] globalConfigFilePath] encoding:OF_STRING_ENCODING_UTF_8];
    }
}

- (bool)udpEnabled {
    return [[settings objectForKey:@"udpEnabled"] boolValue];
}
- (void)setUdpEnabled:(bool)udpEnabled {
    @autoreleasepool {
        [settings setObject:[OFNumber numberWithBool:udpEnabled] forKey:@"udpEnabled"];
        [[settings JSONRepresentationWithOptions:OF_JSON_REPRESENTATION_PRETTY] writeToFile:[[FileManager defaultManager] globalConfigFilePath] encoding:OF_STRING_ENCODING_UTF_8];
    }
}

- (int16_t)udpPort {
    return [[settings objectForKey:@"udpPort"] int16Value];
}
- (void)setUdpPort:(int16_t)udpPort {
    @autoreleasepool {
        [settings setObject:[OFNumber numberWithInt16:udpPort] forKey:@"udpPort"];
        [[settings JSONRepresentationWithOptions:OF_JSON_REPRESENTATION_PRETTY] writeToFile:[[FileManager defaultManager] globalConfigFilePath] encoding:OF_STRING_ENCODING_UTF_8];
    }
}
- (bool)udpLanWorldBroadcastEnabled {
    return [[settings objectForKey:@"udpLanBroadcastEnabled"] boolValue];
}
- (void)setUdpLanWorldBroadcastEnabled:(bool)udpLanWorldBroadcastEnabled {
    @autoreleasepool {
        [settings setObject:[OFNumber numberWithBool:udpLanWorldBroadcastEnabled] forKey:@"udpLanWorldBroadcastEnabled"];
        [[settings JSONRepresentationWithOptions:OF_JSON_REPRESENTATION_PRETTY] writeToFile:[[FileManager defaultManager] globalConfigFilePath] encoding:OF_STRING_ENCODING_UTF_8];
    }
}

- (int64_t)udpServerId  //unique Id for every Minecraft PE install,
                        //never use your own, you will probably not be able to connect
{
    return [[settings objectForKey:@"udpServerId"] int64Value];
}
- (void)setUdpServerId:(int64_t)udpServerId {
    @autoreleasepool {
        [settings setObject:[OFNumber numberWithInt64:udpServerId] forKey:@"udpServerId"];
        [[settings JSONRepresentationWithOptions:OF_JSON_REPRESENTATION_PRETTY] writeToFile:[[FileManager defaultManager] globalConfigFilePath] encoding:OF_STRING_ENCODING_UTF_8];
    }
}

//Game Related Server Settings
- (OFString *)serverBrowserMessage {
    return [settings objectForKey:@"serverBrowserMessage"];
}
- (void)setServerBrowserMessage:(OFString *)serverBrowserMessage {
    @autoreleasepool {
        [settings setObject:serverBrowserMessage forKey:@"serverBrowserMessage"];
        [[settings JSONRepresentationWithOptions:OF_JSON_REPRESENTATION_PRETTY] writeToFile:[[FileManager defaultManager] globalConfigFilePath] encoding:OF_STRING_ENCODING_UTF_8];
    }
}

- (bool)loginWelcomeMessageEnabled {
    return [[settings objectForKey:@"loginWelcomeMessageEnabled"] boolValue];
}
- (void)setLoginWelcomeMessageEnabled:(bool)loginWelcomeMessageEnabled {
    @autoreleasepool {
        [settings setObject:[OFNumber numberWithBool:loginWelcomeMessageEnabled] forKey:@"loginWelcomeMessageEnabled"];
        [[settings JSONRepresentationWithOptions:OF_JSON_REPRESENTATION_PRETTY] writeToFile:[[FileManager defaultManager] globalConfigFilePath] encoding:OF_STRING_ENCODING_UTF_8];
    }
}

- (OFString *)loginWelcomeMessage {
    return [settings objectForKey:@"loginWelcomeMessage"];
}
- (void)setLoginWelcomeMessage:(OFString *)loginWelcomeMessage {
    @autoreleasepool {
        [settings setObject:loginWelcomeMessage forKey:@"loginWelcomeMessage"];
        [[settings JSONRepresentationWithOptions:OF_JSON_REPRESENTATION_PRETTY] writeToFile:[[FileManager defaultManager] globalConfigFilePath] encoding:OF_STRING_ENCODING_UTF_8];
    }
}

//Game Mode
- (uint8_t)defaultGamemode {
    @autoreleasepool {
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
}
- (void)setDefaultGamemode:(uint8_t)defaultGamemode {
    switch (defaultGamemode) {
        case 0:
            [settings setObject:@"SURVIVAL" forKey:@"defaultGamemode"];
            break;
            
        case 1:
            [settings setObject:@"CREATIVE" forKey:@"defaultGamemode"];
            break;
            
        case 2:
            [settings setObject:@"ADVENTURE" forKey:@"defaultGamemode"];
            break;
    }
    @autoreleasepool {
        [[settings JSONRepresentationWithOptions:OF_JSON_REPRESENTATION_PRETTY] writeToFile:[[FileManager defaultManager] globalConfigFilePath] encoding:OF_STRING_ENCODING_UTF_8];
    }
}

- (bool)isHardcore {
    return [[settings objectForKey:@"isHardcore"] boolValue];
}
- (void)setIsHardcore:(bool)isHardcore {
    @autoreleasepool {
        [settings setObject:[OFNumber numberWithBool:isHardcore] forKey:@"isHardcore"];
        [[settings JSONRepresentationWithOptions:OF_JSON_REPRESENTATION_PRETTY] writeToFile:[[FileManager defaultManager] globalConfigFilePath] encoding:OF_STRING_ENCODING_UTF_8];
    }
}

//World Settings
- (int8_t)spawnDimension {
    return [[settings objectForKey:@"defaultSpawnDimension"] int8Value];
}
- (void)setSpawnDimension:(int8_t)spawnDimension {
    @autoreleasepool {
        [settings setObject:[OFNumber numberWithInt8:spawnDimension] forKey:@"spawnDimension"];
        [[settings JSONRepresentationWithOptions:OF_JSON_REPRESENTATION_PRETTY] writeToFile:[[FileManager defaultManager] globalConfigFilePath] encoding:OF_STRING_ENCODING_UTF_8];
    }
}

- (OFDictionary *)dimensions {
    
    OFMutableDictionary *dimensions = [[OFMutableDictionary alloc] init];
    
    OFArray *keys = [[settings objectForKey:@"dimensions"] allKeys];
    for (int i = 0; i<[keys count]; i++) {
        [dimensions setObject:[[settings objectForKey:@"dimensions"] objectForKey:[keys objectAtIndex:i]] forKey:[OFNumber numberWithInt8:[((OFString *)[keys objectAtIndex:i]) decimalValue]]];
    }
    
    return [dimensions autorelease];
    
}
- (void)setDimensions:(OFDictionary *)_dimensions {
    
    @autoreleasepool {
    
        OFMutableDictionary *dimensions = [[OFMutableDictionary alloc] init];
        
        OFArray *keys = [_dimensions allKeys];
        for (int i = 0; i<[keys count]; i++) {
            [dimensions setObject:[_dimensions objectForKey:[keys objectAtIndex:i]] forKey:[OFString stringWithFormat:@"%d", [[keys objectAtIndex:i] int8Value]]];
        }
        
        [settings setObject:dimensions forKey:@"dimensions"];
        [dimensions release];
             
        [[settings JSONRepresentationWithOptions:OF_JSON_REPRESENTATION_PRETTY] writeToFile:[[FileManager defaultManager] globalConfigFilePath] encoding:OF_STRING_ENCODING_UTF_8];
    
    }
}
- (void)addDimension:(int8_t)dimensionNum withGenerator:(WorldGenerator *)generator {
    @autoreleasepool {
        OFMutableDictionary *dict = [[settings objectForKey:@"dimensions"] mutableCopy];
        [dict setObject:[[generator class] description] forKey:[OFNumber numberWithInt8:dimensionNum]];
        [settings setObject:dict forKey:@"dimensions"];
        [dict release];
        [[settings JSONRepresentationWithOptions:OF_JSON_REPRESENTATION_PRETTY] writeToFile:[[FileManager defaultManager] globalConfigFilePath] encoding:OF_STRING_ENCODING_UTF_8];
    }
}
- (void)removeDimension:(int8_t)dimensionNum {
    @autoreleasepool {
        OFMutableDictionary *dict = [[settings objectForKey:@"dimensions"] mutableCopy];
        [dict removeObjectForKey:[OFNumber numberWithInt8:dimensionNum]];
        [settings setObject:dict forKey:@"dimensions"];
        [dict release];
        [[settings JSONRepresentationWithOptions:OF_JSON_REPRESENTATION_PRETTY] writeToFile:[[FileManager defaultManager] globalConfigFilePath] encoding:OF_STRING_ENCODING_UTF_8];
    }
}


//Global World Settings
- (int32_t)seed {
    return [[settings objectForKey:@"seed"] int32Value];
}
- (void)setSeed:(int32_t)seed {
    @autoreleasepool {
        [settings setObject:[OFNumber numberWithInt32:seed] forKey:@"seed"];
        [[settings JSONRepresentationWithOptions:OF_JSON_REPRESENTATION_PRETTY] writeToFile:[[FileManager defaultManager] globalConfigFilePath] encoding:OF_STRING_ENCODING_UTF_8];
    }
}

- (int32_t)maxPlayers {
    return [[settings objectForKey:@"maxPlayers"] int32Value];
}
- (void)setMaxPlayers:(int32_t)maxPlayers {
    @autoreleasepool {
        [settings setObject:[OFNumber numberWithInt32:maxPlayers] forKey:@"maxPlayers"];
        [[settings JSONRepresentationWithOptions:OF_JSON_REPRESENTATION_PRETTY] writeToFile:[[FileManager defaultManager] globalConfigFilePath] encoding:OF_STRING_ENCODING_UTF_8];
    }
}
    
- (of_point_t)defaultSpawnPoint {
    return of_point([[[settings objectForKey:@"defaultSpawnPoint"] objectAtIndex:0] int32Value], [[[settings objectForKey:@"defaultSpawnPoint"] objectAtIndex:1] int32Value]);
}
- (void)setDefaultSpawnPoint:(of_point_t)defaultSpawnPoint {
    @autoreleasepool {
        [settings setObject:[OFArray arrayWithObjects:[OFNumber numberWithInt32:((int32_t)defaultSpawnPoint.x)], [OFNumber numberWithInt32:((int32_t)defaultSpawnPoint.y)], nil] forKey:@"defaultSpawnPoint"];
        [[settings JSONRepresentationWithOptions:OF_JSON_REPRESENTATION_PRETTY] writeToFile:[[FileManager defaultManager] globalConfigFilePath] encoding:OF_STRING_ENCODING_UTF_8];
    }
}

- (uint8_t)difficulty {
    @autoreleasepool {
        OFString *string = [settings objectForKey:@"difficulty"];
        if ([string isEqual:@"PEACEFUL"]) {
            return 0;
        }
        if ([string isEqual:@"EASY"]) {
            return 1;
        }
        if ([string isEqual:@"NORMAL"]) {
            return 2;
        }
        if ([string isEqual:@"HARD"]) {
            return 2;
        }
        return 2;
    }
}
- (void)setDifficulty:(uint8_t)difficulty {
    switch (difficulty) {
        case 0:
            [settings setObject:@"PEACEFUL" forKey:@"difficulty"];
            break;
            
        case 1:
            [settings setObject:@"EASY" forKey:@"difficulty"];
            break;
            
        case 2:
            [settings setObject:@"NORMAL" forKey:@"difficulty"];
            break;
            
        case 3:
            [settings setObject:@"HARD" forKey:@"difficulty"];
            break;
    }
    @autoreleasepool {
        [[settings JSONRepresentationWithOptions:OF_JSON_REPRESENTATION_PRETTY] writeToFile:[[FileManager defaultManager] globalConfigFilePath] encoding:OF_STRING_ENCODING_UTF_8];
    }
}

@end
