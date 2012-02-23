//
//  SnSURLCacheSilo.m
//  SnSFramework
//
//  Created by Johan Attali on 7/27/11.
//  Copyright 2011 Smart&Soft. All rights reserved.
//

#import "SnSURLCacheSilo.h"
#import "SnSCacheItem.h"
#import "SnSCacheException.h"

#define kSnSURLCacheSiloRequestTimeout 5

@implementation SnSURLCacheSilo

@synthesize connectionHandler = _connectionHandler;

#pragma mark - Caching Methods

- (SnSCacheItem*)cachedItemForKey:(NSURLRequest*)iRequest
{
	if (![iRequest isKindOfClass:[NSURLRequest class]])
		SnSLogE(@"The %@ class only works with NSURL keys (%@ given)", self.class, [iRequest class]);
	
	// First try to retreive the item the way we would from the superclass
	SnSCacheItem* aCacheItem = [super cachedItemForKey:iRequest];
	
	// If no item found, fetch it
	if (!aCacheItem)
	{
//		NSData*	aData = nil;
		
//		// If the connection handler protocol is followed, let it handle the request.
//		// This is useful for testing purposes because it lets complete controle to 
//		// the unit test to act on connection
//		if ([_connectionHandler respondsToSelector:@selector(handleServerConnection:)])
//			aData = [_connectionHandler handleServerConnection:iRequest];
//		else
//			aData = [self dataForRequest:iRequest];
//		
//		// If data was retreived
//		if (aData)
//		{
//			// By default put item into memory it will be moved if needed later on by the watcher
//			aCacheItem = [[SnSCacheItem alloc] initWithZone:SnSCacheZoneMemory 
//														key:iRequest 
//													   date:[NSDate date]
//													   data:aData];
//			
//			// Save item
//			[self storeCacheItem:aCacheItem forKey:iRequest];
//		}

	}
	
	return aCacheItem;
}

- (NSData*)dataForRequest:(NSURLRequest*)iRequest
{
	NSError* aResponseError = nil;
	NSData* aResponseData;
	NSURLResponse* aResponse = nil;
	NSData* aReturnedData = nil;
	
	// Retreive data from server
	aResponseData = [NSURLConnection sendSynchronousRequest:iRequest returningResponse:&aResponse error:&aResponseError];
	
	//TODO: Create a special behaviour when download failed (maybe cache a special item)
	if (aResponseError != nil)
		SnSLogE(@"Error while retrieving the requesting URL '%@':  %@", iRequest.URL, [aResponseError localizedFailureReason]);
	
	else if ([aResponse isKindOfClass:[NSHTTPURLResponse class]] && [(NSHTTPURLResponse*)aResponse statusCode] != 200)
		SnSLogE(@"Received a response from server with status code %i corresponding to the URL '%@'", [(NSHTTPURLResponse*)aResponse statusCode], iRequest.URL);
	
	else if (aResponseData == nil)
		SnSLogE(@"There is no data regarding the URL '%@'", iRequest.URL);
	else
		aReturnedData = aResponseData;
	
	return aReturnedData;
}

								  
@end
