//
//  SnSURLConnection.m
//  SnSFramework
//
//  Created by Johan Attali on 01/08/11.
//  Copyright 2011 Smart&Soft. All rights reserved.
//

#import "SnSURLConnection.h"
//#import "SnSMasterCache.h"
#import "SnSCacheItem.h"
#import "SnSLog.h"

@implementation SnSURLConnection

#pragma mark - Init Methods

+ (id)connectionWithRequest:(NSURLRequest *)iRequest
{
	id aConnection = [[[self class] alloc] initWithRequest:iRequest];
	return [aConnection autorelease];
}

- (id) initWithRequest:(NSURLRequest *)iRequest
{
	if ((self = [super init]))
	{
		_request = [iRequest retain];
	}
	
	return self;
}

- (void) dealloc
{
	[_request release];
	
	[super dealloc];
}

#pragma mark - Process Server Calls

+ (NSData *)retreiveDataForReqest:(NSURLRequest *)iRequest
{
	id aConnection  = [[self class] connectionWithRequest:iRequest];
	return [aConnection retreiveData];
}

- (NSData *)retreiveData
{
	NSError* aResponseError = nil;
	NSData* aResponseData = nil;
	NSURLResponse* aResponse = nil;
	
	// Retreive data from server
	aResponseData = [NSURLConnection sendSynchronousRequest:_request returningResponse:&aResponse error:&aResponseError];
	
	[self handleResponse:aResponse data:aResponseData error:aResponseError];
	
	return aResponseData;

}

- (void)process
{
	// Looking for value into cache ?
	if (_request.cachePolicy == NSURLRequestUseProtocolCachePolicy ||
		_request.cachePolicy == NSURLRequestReturnCacheDataElseLoad ||
		_request.cachePolicy == NSURLRequestReloadRevalidatingCacheData)
	{
//		SnSMasterCache* aMasterCache = [SnSMasterCache instance];
//		SnSCacheItem* aCacheItem = [aMasterCache cachedItemForQuery:_request.URL];
		
//		// Item not in cache ?
//		if (0)
//		{
//			// retreive it 
//			// TODO: check the request cache policy for a finer connection system
//			// TODO: add async data fetching
//			NSData* aData = [self retreiveData];
//			
//			// Create cache item
//			aCacheItem = [[SnSCacheItem alloc] initWithKey:_request.URL date:[NSDate date] data:aData];
//			
//			// Store it
//			[aMasterCache storeCacheItem:aCacheItem forQuery:_request.URL];
//			
//			[aCacheItem release];
//		}
	}
}


#pragma mark - Handle Response

- (void)handleResponse:(NSURLResponse*)iResponse data:(NSData*)iData error:(NSError*)iError
{
	//TODO: Create a special behaviour when download failed (maybe cache a special item)
	if (iResponse != nil)
		SnSLogE(@"Error while retrieving the requesting URL '%@':  %@", _request.URL, [iError localizedFailureReason]);
	
	else if ([iResponse isKindOfClass:[NSHTTPURLResponse class]] && [(NSHTTPURLResponse*)iResponse statusCode] != 200)
		SnSLogE(@"Received a response from server with status code %i corresponding to the URL '%@'", [(NSHTTPURLResponse*)iResponse statusCode], _request.URL);
	
	else if (iData == nil)
		SnSLogE(@"There is no data regarding the URL '%@'", _request.URL);
}

@end
