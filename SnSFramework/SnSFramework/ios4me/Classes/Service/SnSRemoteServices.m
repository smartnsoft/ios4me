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
	//------------------------------
	// Variables and Queue
	//------------------------------
	
	// The image data will be modified in the blocks
	__block NSData* aImageData	= nil;
    
	// this will be used to associate a request to its binding view
	NSString* bindStr	= iBindingView ? [NSString stringWithFormat:@"%p", iBindingView] : [NSString stringUnique];
	
	// check if the binding view is an image view
	UIImageView* imageView = [iBindingView isKindOfClass:[UIImageView class]] ? (UIImageView*)iBindingView : nil;
    
	// Create the background queue
	dispatch_queue_t queue = dispatch_queue_create("Image Retrieval", NULL);
    
	// Start animating if passed in parameters
	if ([iLoadingView respondsToSelector:@selector(startAnimating)])
		[(id)iLoadingView startAnimating];
	
	// Override default url if resize asked
	if ([iBindingView isKindOfClass:[UIImageView class]] && (iOption & kSnSImageRetrievalOptionResizeURL))
		iURL = [self urlForResizingServices:iURL binding:(UIImageView*)iBindingView];
	
	//------------------------------
	// Image Construction and Binding
	//------------------------------
	UIImage* (^finalization)(NSData*) = ^ (NSData* d)
	{
 		CGDataProviderRef imgDataProvider = d ? CGDataProviderCreateWithCFData((CFDataRef) d) : nil;

		CGImageRef imgRef = nil;
		
		if ([d isJPG])
			imgRef = CGImageCreateWithJPEGDataProvider(imgDataProvider, NULL, true, kCGRenderingIntentDefault);
		else if ([d isPNG])
			imgRef = CGImageCreateWithPNGDataProvider(imgDataProvider, NULL, true, kCGRenderingIntentDefault);
        
		UIImage* image = d ? [UIImage imageWithCGImage:imgRef] : nil;
		
		if ([iBindingView isKindOfClass:[UIImageView class]] && (iOption & kSnSImageRetrievalOptionResizeToBinding))
			image = [image resizedImageWithContentMode:iBindingView.contentMode
												bounds:iBindingView.bounds.size
								  interpolationQuality:kCGInterpolationMedium];
		
		CGImageRelease(imgRef);
		CGDataProviderRelease(imgDataProvider);
		
		dispatch_async(dispatch_get_main_queue(), ^{
			
			if (image)
			{
				// Only remove the assocition binding view -> request
				// if the image was correctly built.
				// Otherwise you could remove it after a cancelation but also right after another
				// download on the same buiding view has started
				@synchronized(requests_)
				{ [requests_  removeObjectForKey:bindStr]; }
				
				
				if (iOption & kSnSImageRetrievalOptionImageCrossFade)
				{
					CABasicAnimation *crossFade = [CABasicAnimation animationWithKeyPath:@"contents"];
					crossFade.duration = 0.2f;
					crossFade.fromValue = (id)imageView.image.CGImage;
					crossFade.toValue = (id)image.CGImage;
					[imageView.layer addAnimation:crossFade forKey:@"animateContents"];
				}
				
				imageView.image = image;
				
				
				if ([iLoadingView respondsToSelector:@selector(stopAnimating)])
					[(id)iLoadingView stopAnimating];
				
				// if completion block has been set call it
				if (iCompletionBlock)
					iCompletionBlock(image);
                
			}
			
			else {
				
				if (iErrorBlock)
					iErrorBlock(nil);
                
			}
			
		});
		
		return image;
		
	};
	
	//------------------------------
	// Image Download
	//------------------------------
	dispatch_async(queue, ^{
		
		//------------------------------
		// Processing old request
		//------------------------------
		
		// First check if there is already a request corresponding to this view
		ASIHTTPRequest* aOldRequest = [requests_ objectForKey:bindStr];
		
		// If there is, cancel it
		if (aOldRequest)
		{
			SnSLogD(@"Cancelling Image Retrieval [u:%@] [v:%@]", [aOldRequest url], bindStr);
            
			// Cancel old request unless specified not to
			if (!(iOption & kSnSImageRetrievalOptionDoNotCancelRequest))
				[aOldRequest cancel];
			
			@synchronized(requests_)
			{ [requests_ removeObjectForKey:bindStr];}
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
			ASIHTTPRequest* aRequest = [ASIHTTPRequest requestWithURL:iURL];
			[self prepareRequest:aRequest];
			
			SnSLogD(@"Retrieving Image [u:%@] [v:%@]", [aRequest url], bindStr);
			
			// Lock request and add it to the dictionary
			@synchronized(requests_)
            { [requests_ setObject:aRequest forKey:bindStr]; }
			
			[aRequest setFailedBlock:^{
				
				if ([[aRequest error] code] == ASIRequestCancelledErrorType)
					SnSLogD(@"Cancelled Image Retrieval [u:%@] [v:%@]", [aRequest url], bindStr);
				else
					SnSLogE(@"Error Image Retrieval [u:%@] [v:%@] [e:%@]", [aRequest url], bindStr, [[aRequest error] description]);
				
				finalization(nil);
                
				if (iErrorBlock)
				{
					dispatch_async(dispatch_get_main_queue(), ^{
						iErrorBlock([aRequest error]);
					});
				}
                
			}];
			[aRequest setCompletionBlock:^
            {
				
                // status code > 400 : Error
                if([aRequest responseStatusCode] >= 400)
                {
                    finalization(nil);
                    return;
                }
                
                aImageData  = [aRequest responseData];
                
                [cache_ storeData:aImageData forKey:[aRequest url]];
                
                SnSLogD(@"Retrieved Image [u:%@] [s:%d bytes] [v:%@]", [aRequest url], [aImageData length], bindStr);
                
                // create queue for processing asynchronously. This is needed because
                // the ASIHTTPREquest completion is executed on the main thread.
                dispatch_queue_t processing = dispatch_queue_create("Image Processing", NULL);
                
                // dispath finalization block on separate thread
                dispatch_async(processing, ^{ finalization(aImageData); });
                
                // won’t actually go away until queue is empty
                dispatch_release(processing);
                
            }];
            
            [aRequest startAsynchronous];
            
        }
        else
        {
            finalization(aImageData);
        }
        
    });
    
    //won’t actually go away until queue is empty
    dispatch_release(queue);
    
    
    
            }

             @end
