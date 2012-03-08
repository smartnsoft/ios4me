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
	[iRequest setDownloadCache:[ASIDownloadCache sharedCache]];

}

#pragma mark -
#pragma mark Image Retrieval
#pragma mark -

- (void)retrieveImageURL:(NSURL*)iURL binding:(UIImageView*)iBindingView indicator:(UIView*)iLoadingView
{
	//------------------------------
	// Variables and Queue
	//------------------------------
	
	// The image data will be modified in the blocks
	__block NSData* aImageData	= nil;
	
	// this will be used to associate a request to its binding view
	NSString* aBindingViewStr	= iBindingView ? [NSString stringWithFormat:@"%p", iBindingView] : nil;

	// Create the background queue
	dispatch_queue_t aQueue = dispatch_queue_create("Image Retrieval", NULL);
	
	// Start animating if passed in parameters
	if ([iLoadingView respondsToSelector:@selector(startAnimating)])
		[(id)iLoadingView startAnimating];
	
	//------------------------------
	// Image Construction and Binding
	//------------------------------
	void (^finalization)(NSData*) = ^ (NSData* d) {
		
		// make sure the request is diassociated from its binding view
		@synchronized(requests_)
		{ [requests_  removeObjectForKey:aBindingViewStr]; }
		
		UIImage* aImage = [UIImage imageWithData:d];
		
		dispatch_async(dispatch_get_main_queue(), ^{
			
			if (aImage)
			{
				CABasicAnimation *crossFade = [CABasicAnimation animationWithKeyPath:@"contents"];
				crossFade.duration = 0.15f;
				crossFade.fromValue = (id)iBindingView.image.CGImage;
				crossFade.toValue = (id)aImage.CGImage;
				[iBindingView.layer addAnimation:crossFade forKey:@"animateContents"];
				
				iBindingView.image = aImage;				
			}
			
			if ([iLoadingView respondsToSelector:@selector(stopAnimating)])
				[(id)iLoadingView stopAnimating];
		});		
		
	};
	
	//------------------------------
	// Image Download
	//------------------------------
	dispatch_async(aQueue, ^{
		
		//------------------------------
		// Processing old request
		//------------------------------
		
		// First check if there is already a request corresponding to this view
		ASIHTTPRequest* aOldRequest = [requests_ objectForKey:aBindingViewStr];
		
		// If there is, cancel it
		if (aOldRequest)
		{
			SnSLogD(@"Cancelling retrieval for %@: %@ ", aBindingViewStr, [aOldRequest url]);

			[aOldRequest cancel];
			
			@synchronized(requests_)
			{ [requests_ removeObjectForKey:aBindingViewStr]; }
		}	
		
		//------------------------------
		// Checking memory cache
		//------------------------------
		
		for (SnSAbstractCache* aCache in [[SnSCacheChecker instance] caches])
		{
			// Is there cached data associated to that URL
			aImageData = [aCache cachedDataForKey:iURL];
			
			if (aImageData)
			{
				SnSLogD(@"Cached data found for URL: %@ [%d bytes]", iURL, [aImageData length]);
				break;
			}
			
		}		
		
		//------------------------------
		// Request creation
		//------------------------------
		
		// No image found in memory cache ? Fetch it
		if (aImageData == nil)
		{
			__block ASIHTTPRequest* aRequest = [ASIHTTPRequest requestWithURL:iURL];
			[self prepareRequest:aRequest];
			
			SnSLogD(@"Retrieving image: %@", [aRequest url]);
			
			// Lock request and add it to the dictionary 
			@synchronized(requests_)
				{ [requests_ setObject:aRequest forKey:aBindingViewStr]; }
			
			[aRequest setFailedBlock:^{
				
				if ([[aRequest error] code] == ASIRequestCancelledErrorType)
					SnSLogD(@"Cancelled retrieval for image: %@", [aRequest url]);
				else
					SnSLogE(@"Error %@ in image retrieval: %@", [[aRequest error] description], [aRequest url]);
				
				finalization(nil);

			}];
			[aRequest setCompletionBlock:^{
				
				aImageData  = [aRequest responseData];
				
				[[SnSMemoryCache instance] storeData:aImageData forKey:[aRequest url]];
				
				SnSLogD(@"Retrieved image: %@ [%d bytes]", [aRequest url], [aImageData length]);
				
				finalization(aImageData);
			}];
			
			[aRequest startAsynchronous];
			
		}
		else
		{
			finalization(aImageData);
		}
		
	});
	
	//won’t actually go away until queue is empty 
	dispatch_release(aQueue); 	
	
	
}

@end
