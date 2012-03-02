/*
 * (C) Copyright 2009-2011 Smart&Soft SAS (http://www.smartnsoft.com/) and contributors.
 *
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the GNU Lesser General Public License
 * (LGPL) version 3.0 which accompanies this distribution, and is available at
 * http://www.gnu.org/licenses/lgpl.html
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * Lesser General Public License for more details.
 *
 * Contributors:
 *     Smart&Soft - initial API and implementation
 */

#import <Foundation/Foundation.h>

#if SNS_LOG_LEVEL_DEBUG != 0
#	define SNS_LOG_LEVEL 5
#endif

#if SNS_LOG_LEVEL_INFO != 0
#	define SNS_LOG_LEVEL 4
#endif

#if SNS_LOG_LEVEL_WARN != 0
#	define SNS_LOG_LEVEL 3
#endif

#if SNS_LOG_LEVEL_ERROR != 0
#	define SNS_LOG_LEVEL 2
#endif

#if SNS_LOG_LEVEL_FATAL != 0
#	define SNS_LOG_LEVEL 1
#endif

// SnS starting logo

#define SnSLogLogo()	[SnSLog logLogo]

// Clear log file

#if SNS_LOG_FILE != 0					
#	define SnSLogClear()		\
		[SnSLog clearLogFile]
#else
#	define SnSLogClear()
#endif


// No log level has been specified: in that case, we discard all logs

#if SNS_LOG_LEVEL != 0
#	define SnSLog(theLogLevel, theFormat, ...)						\
		[SnSLog log:__FILE__										\
		 lineNumber:__LINE__										\
		   logLevel:(theLogLevel)									\
			 format:(theFormat), ##__VA_ARGS__]
#else
#	define SnSLog(theLogLevel, theFormat, ...)
#endif

#if SNS_LOG_LEVEL >= 5
#	define SnSLogD(theFormat, ...)									\
		[SnSLog log:__FILE__										\
		 lineNumber:__LINE__										\
			 method:__FUNCTION__									\
	       logLevel:SnSLogLevelDebug								\
			 format:(theFormat), ##__VA_ARGS__]
#else
#	define SnSLogD(theFormat, ...)
#endif

#if SNS_LOG_LEVEL >= 4
#	define SnSLogI(theFormat, ...)									\
		[SnSLog log:__FILE__										\
		 lineNumber:__LINE__										\
			 method:__FUNCTION__									\
		   logLevel:SnSLogLevelInfo									\
			 format:(theFormat), ##__VA_ARGS__]
#else
#	define SnSLogI(theFormat, ...)
#endif

#if SNS_LOG_LEVEL >= 3
#	define SnSLogW(theFormat, ...)									\
		[SnSLog log:__FILE__										\
		 lineNumber:__LINE__										\
			 method:__FUNCTION__									\
		   logLevel:SnSLogLevelWarning								\
			 format:(theFormat), ##__VA_ARGS__]

#	define SnSLogEW(theException, theFormat, ...)					\
		[SnSLog logWithStringLevel:__FILE__							\
						lineNumber:__LINE__							\
						  logLevel:SnSLogLevelWarning				\
					logLevelString:@"WARN"							\
						 exception:(theException)					\
							format:(theFormat), ##__VA_ARGS__]
#else
#	define SnSLogW(theFormat, ...)
#	define SnSLogEW(theException, theFormat, ...)
#endif

#if SNS_LOG_LEVEL >= 2
# define SnSLogE(theFormat, ...)									\
		[SnSLog log:__FILE__										\
		 lineNumber:__LINE__										\
		 	 method:__FUNCTION__									\
		   logLevel:SnSLogLevelError								\
			 format:(theFormat), ##__VA_ARGS__]

#	define SnSLogEE(theException, theFormat, ...)					\
		[SnSLog logWithStringLevel:__FILE__							\
						lineNumber:__LINE__							\
						  logLevel:SnSLogLevelError					\
					logLevelString:@"ERROR"							\
						 exception:(theException)					\
							format:(theFormat), ##__VA_ARGS__]
#else
#	define SnSLogE(theFormat, ...)
#	define SnSLogEE(theException, theFormat, ...)
#endif

#if SNS_LOG_LEVEL >= 1
#	define SnSLogF(theFormat, ...)									\
		[SnSLog log:__FILE__										\
		 lineNumber:__LINE__										\
			 method:__FUNCTION__									\
		   logLevel:SnSLogLevelFatal								\
			 format:(theFormat), ##__VA_ARGS__]

#	define SnSLogEF(theException, theFormat, ...)					\
		[SnSLog logWithStringLevel:__FILE__							\
						lineNumber:__LINE__							\
						  logLevel:SnSLogLevelFatal					\
					logLevelString:@"FATAL"							\
						 exception:(theException)					\
							format:(theFormat), ##__VA_ARGS__]
#else
#	define SnSLogF(theFormat, ...)
#	define SnSLogFF(theException, theFormat, ...)
#endif

/**
 * Indicates the log level.
 */
typedef enum
{
  SnSLogLevelDebug		= 5,
  SnSLogLevelInfo		= 4,
  SnSLogLevelWarning	= 3,
  SnSLogLevelError		= 2,
  SnSLogLevelFatal		= 1,
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
 * Log the Smart&Soft logo in a nice Ascii Art
 * (http://goo.gl/Rcd42)
 */
+ (void)logLogo;

/** 
 * This is the main method to log anything with the SnS Framework.
 * If logging on file is activated than it also handled here.
 * @param iStr	The NSString to log
 */
+ (void)logString:(NSString*)iStr;

+ (NSString*)logFilePath;

+ (void)clearLogFile;

/** 
 * Logs a specified string into the application specified log file
 * @param iStr	The NSString to log
 * @param logFilePath The path for the file to log the string in
 */
+ (void)logString:(NSString*)iStr toFile:(NSString*)logFilePath;

/**
 * Do not use, use the macros instead!
 */
+ (void) log:(char *)sourceFile 
  lineNumber:(int)lineNumber 
	  method:(const char*)method
	logLevel:(SnSLogLevel)logLevel 
	  format:(NSString *)format, ...;

///**
// * Do not use, use the macros instead!
// */
//+ (void) logWithStringLevel:(char *)sourceFile 
//				 lineNumber:(int)lineNumber 
//				   logLevel:(SnSLogLevel)logLevel 
//			 logLevelString:(NSString *)logLevelString 
//					 format:(NSString *)format, ...;

/**
 * Do not use, use the macros instead!
 */
+ (void) logWithStringLevel:(char *)sourceFile 
				 lineNumber:(int)lineNumber 
				   logLevel:(SnSLogLevel)logLevel 
			 logLevelString:(NSString *)logLevelString 
				  exception:(NSException *)exception 
					 format:(NSString *)format, ...;

@end
