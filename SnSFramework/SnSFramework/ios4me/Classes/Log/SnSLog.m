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
//  SnSLog.m
//  SnSFramework
//
//  Created by Édouard Mercier on 10/9/2009.
//

#import "SnSLog.h"

/**
 * Taken from http://www.borkware.com/rants/agentm/mlog .
 *
 * TODO: add a logger category, just like in log4j.
 */
@implementation SnSLog

+ (void)logLogo
{
	NSString* aLineA = @"----------------------------------------------------------------------";
	NSString* aLine1 = @"   ___  __  __    __    ____  ____     _     ___  _____  ____  ____ ";
	NSString* aLine2 = @"  / __)(  \\/  )  /__\\  (  _ \\(_  _)   ( )   / __)(  _  )( ___)(_  _)";
	NSString* aLine3 = @"  \\__ \\ )    (  /(__)\\  )   /  )(     /_\\/  \\__ \\ )(_)(  )__)   )(  ";
	NSString* aLine4 = @"  (___/(_/\\/\\_)(__)(__)(_)\\_) (__)   (__/\\  (___/(_____)(__)   (__)";
	
	NSString* aStr = [[NSString alloc] initWithFormat:@"Powered by: \n\n%@\n%@\n%@\n%@\n%@\n%@\n\n", aLineA, aLine1, aLine2, aLine3, aLine4, aLineA];
	
	[self logString:aStr];
	
	[aStr release];

}

+ (void)logString:(NSString *)iStr
{
	// We'll log strings asynchrnously into a low priority quue
	dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0); 
	
	// This will be used to make sure that the strings are logged 
	// in the same order they came in
	static NSString* _lock_ = nil;
	if (_lock_ == nil)
		_lock_ = [[NSString alloc] init];

	// log everything in the background especially because logging
	// into the file will be SLOW !
	dispatch_async(queue, ^{
		
		@synchronized(_lock_)
		{
			NSLog(@"%@", iStr);

#if SNS_LOG_FILE !=0
			NSDate* aDate = [NSDate date];
			NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
			[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
			[self logString:[NSString stringWithFormat:@"%@ %@",[dateFormatter stringFromDate:aDate], iStr] toFile:[self logFilePath]];
			[dateFormatter release];
#endif
		}
	});
	

	
}

+ (NSString *)logFilePath
{
	NSString* aFileName = [[[NSProcessInfo processInfo] processName] stringByAppendingString:@".log"];
	
	aFileName = [aFileName stringByReplacingOccurrencesOfString:@" " withString:@"_"];
	
	NSString* aFilePath = [[SnSUtils applicationCachesPath] stringByAppendingPathComponent:aFileName];
	
	
	return aFilePath;
}

+ (void)clearLogFile
{
	NSString* aFilePath = [self logFilePath];
	NSError* aError = nil;	
	NSFileManager* aFileManager = [NSFileManager defaultManager];

	if ([aFileManager fileExistsAtPath:aFilePath])
	{
		[aFileManager removeItemAtPath:aFilePath error:&aError];
		if (aError != nil)
			SnSLogE(@"Failed to remove cache with reason %@", [aError description]);
	}
	
	BOOL aIsFileCreated = [aFileManager createFileAtPath:aFilePath contents:nil attributes:nil];
	
	if (!aIsFileCreated)
		SnSLogE(@"Failed to create log file at path %@", aFilePath);
}

+ (void)logString:(NSString *)iStr toFile:(NSString *)logFilePath
{
	NSString* aFilePath = [self logFilePath];
	
	iStr = [iStr stringByAppendingString:@"\n"];
	
	// Use a file handle to write at the end of the file
	NSFileHandle *aFileHandler = [NSFileHandle fileHandleForWritingAtPath:aFilePath];
	[aFileHandler seekToEndOfFile];
	[aFileHandler writeData:[iStr dataUsingEncoding:NSUTF8StringEncoding]];
	[aFileHandler closeFile];
	
}

+ (void) log:(char *)sourceFile 
  lineNumber:(int)lineNumber
	  method:(char*)method
	logLevel:(SnSLogLevel)logLevel 
	  format:(NSString *)format, ...
{
	// We ignore the log the trigger does not match
#ifndef SNS_LOG_LEVEL
	return;
#endif
	
	NSString * logLevelString;
	switch (logLevel)
	{
		case SnSLogLevelDebug:    
		default:
			logLevelString = @"DBG";
			break;
		case SnSLogLevelInfo:
			logLevelString = @"INF";
			break;
		case SnSLogLevelWarning:
			logLevelString = @"WRN";
			break;
		case SnSLogLevelError:
			logLevelString = @"ERR";
			break;
		case SnSLogLevelFatal:
			logLevelString = @"FTL";
			break;
	}
	
	NSString * filePath = [[NSString alloc] initWithBytes:sourceFile length:strlen(sourceFile) encoding:NSUTF8StringEncoding];
	
	va_list arguments;
	va_start(arguments, format);
	const NSString* str = [[NSString alloc] initWithFormat:format arguments:arguments];
	va_end(arguments);
	
	NSString* aStringToLog = [[NSString alloc] initWithFormat:@"{%@ - %s:%d %s} %@", logLevelString, [[filePath lastPathComponent] UTF8String], lineNumber, method, str];
	
	[self logString:aStringToLog];
	
	[str release];
	[aStringToLog release];
	[filePath release];
}

+ (void) logWithStringLevel:(char *)sourceFile 
				 lineNumber:(int)lineNumber 
				   logLevel:(SnSLogLevel)logLevel 
			 logLevelString:(NSString *)logLevelString 
				  exception:(NSException *)exception
					 format:(NSString *)format, ...
{
#ifndef SNS_LOG_LEVEL
	return;
#endif
	
	NSString * filePath = [[NSString alloc] initWithBytes:sourceFile length:strlen(sourceFile) encoding:NSUTF8StringEncoding];
	va_list arguments;
	va_start(arguments, format);
	const NSString * print = [[NSString alloc] initWithFormat:format arguments:arguments];
	// Taken from http://stackoverflow.com/questions/1282364/iphone-exception-handling
	// The reference discussion on Apple is under http://developer.apple.com/mac/library/documentation/Cocoa/Conceptual/Exceptions/Tasks/ControllingAppResponse.html#//apple_ref/doc/uid/20000473-DontLinkElementID_3
	const NSString * allPrint = [[NSString alloc] initWithFormat:@"%@\nException:%@\n%@", print, [exception reason], [exception callStackReturnAddresses]];
	va_end(arguments);
	
	NSString* aStringToLog = [[NSString alloc] initWithFormat:@"[%@ - %s:%d] %@", logLevelString, /*[[NSThread currentThread] name],*/ [[filePath lastPathComponent] UTF8String], lineNumber, allPrint];
	
	[self logString:aStringToLog];
	
	[allPrint release];
	[print release];
	[filePath release];  
	[aStringToLog release];
}

@end
