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

- (BOOL)isCachedImageURL:(NSURL *)iURL
{
	//------------------------------
	// Checking memory cache
	//------------------------------
	
	for (SnSAbstractCache* aCache in [[SnSCacheChecker instance] caches])
	{
		// Is there cached data associated to that URL
		NSData* aImageData = [aCache cachedDataForKey:iURL];
		
		if (aImageData)
		{
			SnSLogD(@"Cached data found for [u:%@] [s:%d bytes]", iURL, [aImageData length]);
			return YES;
		}
	}	
	
	//------------------------------
	// Checking ASI Cache
	//------------------------------
	
	ASIHTTPRequest* aRequest = [ASIHTTPRequest requestWithURL:iURL];
	
	[self prepareRequest:aRequest];
	
	return [[ASIDownloadCache sharedCache] isCachedDataCurrentForRequest:aRequest];
}

- (void)retrieveImageURL:(NSURL *)iURL binding:(UIImageView *)iBindingView indicator:(UIView *)iLoadingView
{
	[self retrieveImageURL:iURL binding:iBindingView indicator:iLoadingView completionBlock:nil errorBlock:nil];
}

- (void)retrieveImageURL:(NSURL*)iURL
				 binding:(UIImageView*)iBindingView 
			   indicator:(UIView*)iLoadingView 
		 completionBlock:(SnSImageCompletionBlock)iCompletionBlock 
			  errorBlock:(SnSImageErrorBlock)iErrorBlock
{
	//------------------------------
	// Variables and Queue
	//------------------------------
	
	// The image data will be modified in the blocks
	__block NSData* aImageData	= nil;
	
	// this will be used to associate a request to its binding view
	NSString* aBindingViewStr	= iBindingView ? [NSString stringWithFormat:@"%p", iBindingView] : [NSString stringUnique] ;
	
	// check if the binding view is an image view
	UIImageView* aImageView = [iBindingView isKindOfClass:[UIImageView class]] ? iBindingView : nil;

	// Create the background queue
	dispatch_queue_t aQueue = dispatch_queue_create("Image Retrieval", NULL);
	
	// Start animating if passed in parameters
	if ([iLoadingView respondsToSelector:@selector(startAnimating)])
		[(id)iLoadingView startAnimating];
	
	//------------------------------
	// Image Construction and Binding
	//------------------------------
	UIImage* (^finalization)(NSData*) = ^ (NSData* d) {
				
		UIImage* aImage = [UIImage imageWithData:d];
		
		dispatch_async(dispatch_get_main_queue(), ^{
			
			if (aImage)
			{
				// Only remove the assocition binding view -> request
				// if the image was correctly built.
				// Otherwise you could remove it after a cancelation but also right after another
				// download on the same buiding view has started
				@synchronized(requests_)
				{ [requests_  removeObjectForKey:aBindingViewStr]; }
				
				CABasicAnimation *crossFade = [CABasicAnimation animationWithKeyPath:@"contents"];
				crossFade.duration = 0.2f;
				crossFade.fromValue = (id)aImageView.image.CGImage;
				crossFade.toValue = (id)aImage.CGImage;
				[aImageView.layer addAnimation:crossFade forKey:@"animateContents"];
				
				aImageView.image = aImage;				
				
				
				if ([iLoadingView respondsToSelector:@selector(stopAnimating)])
					[(id)iLoadingView stopAnimating];
				
				// if completion block has been set call it
				if (iCompletionBlock)
					iCompletionBlock(aImage);					

			}
			
			else {
				
				if (iErrorBlock)
					iErrorBlock(nil);

			}
			
		});	
		
		return aImage;
		
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
			SnSLogD(@"Cancelling Image Retrieval [u:%@] [v:%@]", [aOldRequest url], aBindingViewStr);

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
				SnSLogD(@"Cached data found for [u:%@] [s:%d bytes]", iURL, [aImageData length]);
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
			
			SnSLogD(@"Retrieving Image [u:%@] [v:%@]", [aRequest url], aBindingViewStr);
			
			// Lock request and add it to the dictionary 
			@synchronized(requests_)
				{ [requests_ setObject:aRequest forKey:aBindingViewStr]; }
			
			[aRequest setFailedBlock:^{
				
				if ([[aRequest error] code] == ASIRequestCancelledErrorType)
					SnSLogD(@"Cancelled Image Retrieval [u:%@] [v:%@]", [aRequest url], aBindingViewStr);
				else
					SnSLogE(@"Error Image Retrieval [u:%@] [v:%@] [e:%@]", [aRequest url], aBindingViewStr, [[aRequest error] description]);
				
				finalization(nil);
								
				if (iErrorBlock)
				{
					dispatch_async(dispatch_get_main_queue(), ^{
						iErrorBlock([aRequest error]);
					});						
				}

			}];
			[aRequest setCompletionBlock:^{
				
				aImageData  = [aRequest responseData];
				
				[[SnSMemoryCache instance] storeData:aImageData forKey:[aRequest url]];
				
				SnSLogD(@"Retrieved Image [u:%@] [s:%d bytes] [v:%@]", [aRequest url], [aImageData length], aBindingViewStr);
				
				UIImage* aImage = finalization(aImageData);
				
				
					
				
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
