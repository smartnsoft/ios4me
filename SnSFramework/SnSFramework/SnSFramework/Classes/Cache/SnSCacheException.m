//
//  SnSCacheException.m
//  SnSFramework
//
//  Created by Johan Attali on 7/27/11.
//  Copyright 2011 Smart&Soft. All rights reserved.
//

#import "SnSCacheException.h"

#define kSnSCacheExceptionName @"SnSCacheException"

NSString *const SnSCacheErrorDomain = @"SnSCacheErrorDomain";
NSString *const SnSCacheExceptionName = @"SnSCacheExceptionName";

@implementation SnSCacheError

@synthesize reason = _reason;

#pragma mark - Init Methods

+ (id)errorWithCode:(SnSCacheErrorType)iCode userInfo:(NSDictionary *)iUserInfo
{
	id aError = [[[self class] alloc] initWithCode:iCode userInfo:iUserInfo];
	return [aError autorelease];
}

- (id)initWithCode:(SnSCacheErrorType)iCode userInfo:(NSDictionary *)iUserInfo
{
	if ((self = [super initWithDomain:SnSCacheErrorDomain code:iCode userInfo:iUserInfo]))
	{
		_reason = [[self extraInformationFromCode:iCode] retain];
	}
	
	return self;
		
}

+ (id)errorWithCode:(SnSCacheErrorType)iCode localizedDescription:(NSString *)iDescription
{
	id aError = [[self alloc] initWithCode:iCode localizedDescription:iDescription];
	return [aError autorelease];
}

- (id)initWithCode:(SnSCacheErrorType)iCode localizedDescription:(NSString *)iDescription
{
	self = [self initWithCode:iCode
					 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:iDescription, NSLocalizedDescriptionKey, nil]];
	
	[_reason stringByAppendingString:iDescription];
	
	return  self;
}

- (NSString *)extraInformationFromCode:(SnSCacheErrorType)iCode
{
	NSString* aReason = [NSString stringWithFormat:@"Unkown reason"];
	switch (iCode) 
	{
		case SnSCacheErrorKeysClassNotMatch:
			aReason = @"The key class being stored is different from the one expected by the cache";
			break;
			
		case SnSCacheErrorURLExpected:
			aReason = @"A key of class NSURL is expected";
			break;
			
		case SnSCacheErrorCacheNotFound:
			aReason = @"Cache Not Found";
			break;
			
		case SnSCacheErrorTooManySilosFound:
			aReason = @"Too many silos found";
			break;
			
		case SnSCacheErrorArchiveFailed:
			aReason = @"Failed to archive item";
			break;
			
		case SnSCacheErrorUnarchiveFailed:
			aReason = @"Failed to unarchive item";
			break;
			
		case SnSCacheErrorCacheCreateFailed:
			aReason = @"Failed to create cache on disk";
			break;
			
		case SnSCacheErrorCacheDeleteFailed:
			aReason = @"Failed to delete cache on disk";
			break;
			
		case SnSCacheErrorLoadFailed:
			aReason = @"Failed to load cache silos";
			break;
	}
	
	return aReason;
}

- (void)dealloc
{
	[_reason release];
	[super dealloc];
}

@end

@implementation SnSCacheException

#pragma mark - Properties

#pragma mark - Init Methods

+ (id)exceptionWithError:(SnSCacheError *)iError
{
	id aException = [[[self class] alloc] initWithError:iError];
	return [aException autorelease];
}

- (id)initWithError:(SnSCacheError *)iError
{
	self = [super initWithName:SnSCacheExceptionName reason:iError.reason userInfo:iError.userInfo];
	
	return self;
	
}

//
//- (SnSCacheException*) initWithType:(SnSCacheExceptionType)iType
//{
//	if ((self = [super initWithName:kSnSCacheExceptionName 
//							 reason:[self reasonFromType:iType]
//						   userInfo:nil]))
//	{
//		_type = iType;
//	}
//	return self;
//}
//
//+ (SnSCacheException*) exceptionWithType:(SnSCacheExceptionType)iType
//{
//	return [[[SnSCacheException alloc] initWithType:iType] autorelease];
//}
//
//#pragma mark - SnSCacheException Specific Methods
//
//- (NSString*)reasonFromType:(SnSCacheExceptionType)iType
//{
//	return [self reasonFromType:iType param:nil];
//}
//
//- (NSString*)reasonFromType:(SnSCacheExceptionType)iType
//{
//	NSString* aReason = [NSString stringWithFormat:@"Unkown %@ reason", self.class];
//	switch (iType) 
//	{
//		case SnSCacheExceptionKeysClassNotMatch:
//			aReason = @"The key class being stored is different from the one expected by the cache";
//			break;
//			
//		case SnSCacheExceptionURLExpected:
//			aReason = @"A key of class NSURL is expected";
//			break;
//		case SnSCacheExceptionURLExpected:
//			aReason = [NSString stringWithFormat:@"Failed to execute request for "
//			break;
//	}
//	
//	return aReason;
//}

@end
