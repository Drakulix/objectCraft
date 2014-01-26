//
//  globals.h
//  MinecraftServer
//
//  Created by Victor Brekenfeld on 23.01.14.
//  Copyright (c) 2014 Victor Brekenfeld. All rights reserved.
//

#ifdef __OBJC__

#define Log(...) of_log((OFConstantString *)__VA_ARGS__)

#define LOG_LEVEL_VERBOSE
#define LOG_LEVEL_DEBUG
#define LOG_LEVEL_INFO
#define LOG_LEVEL_WARN
#define LOG_LEVEL_ERROR

#define NOOP do {} while(0)

#ifdef LOG_LEVEL_ERROR
#define LogError(...) Log(__VA_ARGS__)
#else
#define LogError(...) NOOP
#endif

#ifdef LOG_LEVEL_WARN
#define LogWarn(...) Log(__VA_ARGS__)
#else
#define LogWarn(...) NOOP
#endif

#ifdef LOG_LEVEL_INFO
#define LogInfo(...) Log(__VA_ARGS__)
#else
#define LogInfo(...) NOOP
#endif

#ifdef LOG_LEVEL_DEBUG
#define LogDebug(...) NSLog(__VA_ARGS__)
#else
#define LogDebug(...) NOOP
#endif

#ifdef LOG_LEVEL_VERBOSE
#define LogVerbose(...) NSLog(__VA_ARGS__)
#else
#define LogVerbose(...) NOOP
#endif

#endif