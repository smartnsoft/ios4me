//
//  SnSRemoteServices.m
//  ios4me
//
//  Created by Johan Attali on 06/03/12.
//  Copyright (c) 2012 Smart&Soft. All rights reserved.
//

#import "SnSRemoteServices.h"

#import <ASIHTTPFramework/ASIHTTPFramework.h>

@implementation SnSRemoteServices
@synthesize requests = requests_;

#pragma mark -
#pragma mark NSObject
#pragma mark -

- (id)init
{
	if ((self = [super init]))
	{
		requests_ = [[NSMutableDictionary alloc] init];
	}
	
	return self;
}

- (void)dealloc
{
	[requests_ release];
	
	[super dealloc];
}

#pragma mark -
#pragma mark Preparation
#pragma mark -

- (void)prepareRequest:(ASIHTTPRequest *)iRequest
{
	SnSLogW(@"This method will have a default behaviour and should be overwritten in your children class %@", [self class]);
	
	[iRequest setCachePolicy:ASIOnlyLoadIfNotCachedCachePolicy];
	[iRequest setCacheStoragePolicy:ASICacheForSessionDurationCacheStoragePolicy];
}

#pragma mark -
#pragma mark Image Retrieval
#pragma mark -

- (void)retrieveImageURL:(NSURL*)iURL binding:(UIImageView*)iBindingView indicator:(SnSLoadingView*)iLoadingView
{
	__block NSData* aImageData	= nil;
	NSString* aBindingViewStr	= [NSString stringWithFormat:@"%p", iBindingView];

	// Create the background queue
	dispatch_queue_t aQueue = dispatch_queue_create("Image Retrieval", NULL);
	
	//------------------------------
	// 1. Process Old Request
	//------------------------------
	dispatch_sync(aQueue, ^{
				
		// First check if there is already a request corresponding to this view
		ASIHTTPRequest* aOldRequest = [requests_ objectForKey:aBindingViewStr];
		
		// If there is, cancel it
		if (aOldRequest)
		{
			[aOldRequest cancel];
			
			@synchronized(requests_)
			{ [requests_ removeObjectForKey:aBindingViewStr]; }
		}	
	});
	
	//------------------------------
	// 2. Memory Cache
	//------------------------------
	dispatch_sync(aQueue, ^{		
		for (SnSAbstractCache* aCache in [[SnSCacheChecker instance] caches])
		{
			// Is there cached data associated to that URL
			aImageData = [aCache cachedDataForKey:iURL];
			
			if (aImageData)
			{
				SnSLogD(@"Cached data found for URL: %@", iURL);
				break;
			}
			
		}
	});
	
	//------------------------------
	// 3. Image Construction
	//------------------------------
	dispatch_sync(aQueue, ^{
		// No image found in memory cache ? Fetch it
		if (aImageData == nil)
		{
			ASIHTTPRequest* aRequest = [ASIHTTPRequest requestWithURL:iURL];
			[self prepareRequest:aRequest];
			
			SnSLogD(@"Retrieving image: %@", [aRequest url]);
			
			// Lock request and add it to the dictionary 
			@synchronized(requests_)
				{ [requests_ setObject:aRequest forKey:aBindingViewStr]; }
			
			// The download can be synchrounous since GCD will be running this code
			// in another thread
			[aRequest startSynchronous];
			
			@synchronized(requests_)
				{ [requests_  removeObjectForKey:aBindingViewStr]; }
			
			aImageData  = [aRequest responseData];
			
			SnSLogD(@"Retrieved image: %@ [%d bytes]", [aRequest url], [aImageData length]);
		}
		
		UIImage* aImage = [UIImage imageWithData:aImageData];
		
		// Process is done, call the completion block in the main thread
		dispatch_async(dispatch_get_main_queue(), ^{
			iBindingView.image = aImage;
			
			[iLoadingView stopAnimating];
		});
	});
	
	//won’t actually go away until queue is empty 
	dispatch_release(aQueue); 	
	
	
}

@end
