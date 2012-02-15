/* 
 * Copyright (C) 2009 Smart&Soft.
 * All rights reserved.
 *
 * The code hereby is the full property of Smart&Soft, SIREN 517 961 744.
 * http://www.smartnsoft.com - contact@smartnsoft.com
 * 
 * You are not allowed to use the source code or the resulting binary code, nor to modify the source code, without prior permission of the owner.
 *
 * This library is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 */

//
//  SnSLog.h
//  SnSFramework
//
//  Created by Édouard Mercier on 10/9/2009.
//

#import <Foundation/Foundation.h>

#if SNS_LOG_LEVEL_DEBUG != 0
#define SNS_LOG_LEVEL 5
#endif
#if SNS_LOG_LEVEL_INFO != 0
#define SNS_LOG_LEVEL 4
#endif
#if SNS_LOG_LEVEL_WARN != 0
#define SNS_LOG_LEVEL 3
#endif
#if SNS_LOG_LEVEL_ERROR != 0
#define SNS_LOG_LEVEL 2
#endif
#if SNS_LOG_LEVEL_FATAL != 0
#define SNS_LOG_LEVEL 1
#endif
// No log level has been specified: in that case, we discard all logs

#if SNS_LOG_LEVEL != 0
#define SnSLog(theLogLevel, theFormat, ...) [SnSLog logToFile:__FILE__ lineNumber:__LINE__ logLevel:(theLogLevel) format:(theFormat), ##__VA_ARGS__]
#else
#define SnSLog(theLogLevel, theFormat, ...)
#endif
#if SNS_LOG_LEVEL >= 5
#define SnSLogD(theFormat, ...) [SnSLog logWithStringLevel:__FILE__ lineNumber:__LINE__ logLevel:SnSLogLevelDebug logLevelString:@"DEBUG" format:(theFormat), ##__VA_ARGS__]
#else
#define SnSLogD(theFormat, ...)
#endif
#if SNS_LOG_LEVEL >= 4
#define SnSLogI(theFormat, ...) [SnSLog logWithStringLevel:__FILE__ lineNumber:__LINE__ logLevel:SnSLogLevelInfo logLevelString:@"INFO" format:(theFormat), ##__VA_ARGS__]
#else
#define SnSLogI(theFormat, ...)
#endif
#if SNS_LOG_LEVEL >= 3
#define SnSLogW(theFormat, ...) [SnSLog logWithStringLevel:__FILE__ lineNumber:__LINE__ logLevel:SnSLogLevelWarning logLevelString:@"WARN" format:(theFormat), ##__VA_ARGS__]
#define SnSLogEW(theException, theFormat, ...) [SnSLog logWithStringLevel:__FILE__ lineNumber:__LINE__ logLevel:SnSLogLevelWarning logLevelString:@"WARN" exception:(theException) format:(theFormat), ##__VA_ARGS__]
#else
#define SnSLogW(theFormat, ...)
#define SnSLogEW(theException, theFormat, ...)
#endif
#if SNS_LOG_LEVEL >= 2
#define SnSLogE(theFormat, ...) [SnSLog logWithStringLevel:__FILE__ lineNumber:__LINE__ logLevel:SnSLogLevelError logLevelString:@"ERROR" format:(theFormat), ##__VA_ARGS__]
#define SnSLogEE(theException, theFormat, ...) [SnSLog logWithStringLevel:__FILE__ lineNumber:__LINE__ logLevel:SnSLogLevelError logLevelString:@"ERROR" exception:(theException) format:(theFormat), ##__VA_ARGS__]
#else
#define SnSLogE(theFormat, ...)
#define SnSLogEE(theException, theFormat, ...)
#endif
#if SNS_LOG_LEVEL >= 1
#define SnSLogF(theFormat, ...) [SnSLog logWithStringLevel:__FILE__ lineNumber:__LINE__ logLevel:SnSLogLevelFatal logLevelString:@"FATAL" format:(theFormat), ##__VA_ARGS__]
#define SnSLogEF(theException, theFormat, ...) [SnSLog logWithStringLevel:__FILE__ lineNumber:__LINE__ logLevel:SnSLogLevelFatal logLevelString:@"FATAL" exception:(theException) format:(theFormat), ##__VA_ARGS__]
#else
#define SnSLogF(theFormat, ...)
#define SnSLogFF(theException, theFormat, ...)
#endif

/**
 * Indicates the log level.
 */
typedef enum
{
  SnSLogLevelDebug = 5,
  SnSLogLevelInfo = 4,
  SnSLogLevelWarning = 3,
  SnSLogLevelError = 2,
  SnSLogLevelFatal = 1,
}
SnSLogLevel;

/**
 * Defines some helper functions and macros for logging.
 *
 * The log helpers should be exclusively used from macros, so that some logs can be removed from the compilation process
 * for a production environment purpose. The <code>SnSLogD</code>, <code>SnSLogI</code>, <code>SnSLogW</code>,
 * <code>SnSLogE</code> and <code>SnSLogF</code> macros should be used, and not directly the static methods! 
 */
@interface SnSLog : NSObject
{
}

/**
 * Do not use, use the macros instead!
 */
+ (void) log:(char *)sourceFile lineNumber:(int)lineNumber logLevel:(SnSLogLevel)logLevel format:(NSString *)format, ...;

/**
 * Do not use, use the macros instead!
 */
+ (void) logWithStringLevel:(char *)sourceFile lineNumber:(int)lineNumber logLevel:(SnSLogLevel)logLevel logLevelString:(NSString *)logLevelString format:(NSString *)format, ...;

/**
 * Do not use, use the macros instead!
 */
+ (void) logWithStringLevel:(char *)sourceFile lineNumber:(int)lineNumber logLevel:(SnSLogLevel)logLevel logLevelString:(NSString *)logLevelString exception:(NSException *)exception format:(NSString *)format, ...;

@end
