//
//  SnSRemoteServices.m
//  ios4me
//
//  Created by Johan Attali on 06/03/12.
//  Copyright (c) 2012 Smart&Soft. All rights reserved.
//

#import "SnSRemoteServices.h"

#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"

@implementation SnSRemoteServices
@synthesize requests = requests_;
@synthesize cache = cache_;

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

#pragma mark SnSSingleton

- (void)reset
{
    self.cache = nil;
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

- (NSURL *)urlForResizingServices:(NSURL *)iImageURL binding:(UIImageView *)iBindingView
{
	SnSLogW(@"This method will have a default behaviour and should be overwritten in your children class %@", [self class]);
	
	return iImageURL;
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

- (void)retrieveImageURL:(NSURL*)iURL binding:(UIView*)iBindingView indicator:(UIView*)iLoadingView
{
	[self retrieveImageURL:iURL
				   binding:iBindingView
				 indicator:iLoadingView
					option:kSnSImageRetrievalOptionNone
		   completionBlock:nil
				errorBlock:nil];
}

- (void)retrieveImageURL:(NSURL*)iURL
				 binding:(UIView*)iBindingView
			   indicator:(UIView*)iLoadingView
				  option:(SnSImageRetrievalOption)iOption
{
	[self retrieveImageURL:iURL
				   binding:iBindingView
				 indicator:iLoadingView
					option:iOption
		   completionBlock:nil
				errorBlock:nil];
}

- (void)retrieveImageURL:(NSURL*)iURL
				 binding:(UIView*)iBindingView
			   indicator:(UIView*)iLoadingView
		 completionBlock:(SnSImageCompletionBlock)iCompletionBlock
			  errorBlock:(SnSImageErrorBlock)iErrorBlock
{
	[self retrieveImageURL:iURL
				   binding:iBindingView
				 indicator:iLoadingView
					option:kSnSImageRetrievalOptionNone
		   completionBlock:iCompletionBlock
				errorBlock:iErrorBlock];
}

- (void)retrieveImageURL:(NSURL*)iURL
				 binding:(UIView*)iBindingView
			   indicator:(UIView*)iLoadingView
				  option:(SnSImageRetrievalOption)iOption
		 completionBlock:(SnSImageCompletionBlock)iCompletionBlock
			  errorBlock:(SnSImageErrorBlock)iErrorBlock
{
	SnSLogD(@"[RemoteServices] - retrieving image %@ for %@", iURL, iBindingView);
    
    
}

@end
