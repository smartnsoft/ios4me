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
//  SnSImageDownloader.m
//  SnSFramework
//
//  Created by Édouard Mercier on 10/10/2009.
//

#import "SnSImageDownloader.h"

#import "SnSLog.h"
#import "SnSURLCache.h"
#import "SnSUtils.h"

#import <UIKit/UIImage.h> 

@implementation SnSImageDownloader

@synthesize work;

+ (SnSImageDownloader *) instance
{
    static SnSImageDownloader * _instance;
    @synchronized (self)
    {
        if (_instance == NULL)
        {
            _instance = [[self alloc] init];
        }
    }
    return _instance;
}

@end

#pragma mark -
#pragma mark SnSDownloadImageOperation

@interface SnSDownloadImageOperation(Private)

- (id) initWith:(BOOL)useCache andUrl:(NSString *)url;// andDelegate:(DownloadImageDelegate *) theCallback;
- (void) enqueue:(SnSDownloadImageOperation *)downloadImageOperation;
- (NSData *) downloadImage;
- (void) onDataDownloaded:(NSData *)data;

@end

/**
 * The inspiration is taken from http://www.cimgf.com/2008/02/16/cocoa-tutorial-nsoperation-and-nsoperationqueue .
 */
@implementation SnSDownloadImageOperation

- (id) initWith:(BOOL)useCache andUrl:(NSString *)url// andDelegate:(DownloadImageDelegate *) theCallback
{
    if (([super init]))
    {
		_useCache	= useCache;
		_url		= [url retain];
		imageUrl	= [[NSURL URLWithString:_url] retain];
		urlRequest	= [[NSURLRequest alloc] initWithURL:imageUrl cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60.0];
		//callback = theCallback;

    }
       return self;
}

- (void) dealloc
{
    [imageUrl release];
    [_url release];
    [urlRequest release];
    [callback release];
	
    [super dealloc];
}

- (void) enqueue:(SnSDownloadImageOperation *)downloadImageOperation
{
    static NSOperationQueue * queue;
    if (queue == nil)
	{
        queue = [[NSOperationQueue alloc] init];
		[queue setMaxConcurrentOperationCount:1];
	}
    
    //SnSLogD(@"Handling the image with URL '%@'", _url);
    if (_useCache == YES)
    {
        NSURLCache * urlCache = [NSURLCache sharedURLCache];
		if (urlCache != nil) 
		{
			NSCachedURLResponse * cachedUrlResponse =  [urlCache cachedResponseForRequest:urlRequest];
			if (cachedUrlResponse == nil)
			{
				[queue addOperation:downloadImageOperation];
			}
			else
			{
				// We suppose that the callie is from the GUI thread!
				NSData * data = [cachedUrlResponse data];
				[self onDataDownloaded:data];
			}
		}
    }
    else
        [queue addOperation:downloadImageOperation];
}

- (void) main
{
    if (_url == nil || [_url length] == 0)
    {
        return;
    }
    
    NSData * data = [self downloadImage];
    // The notification is done in the GUI thread
    [self performSelectorOnMainThread:@selector(onDataDownloaded:) withObject:data waitUntilDone:NO];
}

- (NSData *) downloadImage
{
    // TODO test
    NSMutableURLRequest * theUrlRequest = [[NSMutableURLRequest alloc] initWithURL:imageUrl 
                                                                       cachePolicy:NSURLRequestReturnCacheDataElseLoad 
                                                                   timeoutInterval:60];
    NSData * data = [[SnSURLCache instance] getFromCache:theUrlRequest];
    
    
    //NSData * data = [NSData dataWithContentsOfURL:imageUrl];
    if (_useCache == YES && [data length] > 0)
    {		
        NSURLResponse * urlResponse = [[NSURLResponse alloc] initWithURL:imageUrl 
																MIMEType:nil 
												   expectedContentLength:[data length] 
														textEncodingName:nil];
		
        NSCachedURLResponse * cachedUrlResponse = [[NSCachedURLResponse alloc] initWithResponse:urlResponse 
																						   data:data 
																					   userInfo:nil
																				  storagePolicy:NSURLCacheStorageAllowed] ;
		
        [[NSURLCache sharedURLCache] storeCachedResponse:cachedUrlResponse forRequest:urlRequest];
		
		// Release objects
        [cachedUrlResponse release];
        [urlResponse release];
    }
	
	[theUrlRequest release];
	
    return data;
}

@end

@implementation SnSImageViewDownloadImageOperation

- (id) initWith:(BOOL)useCache andTarget:(UIImageView *)target andUrl:(NSString *)url andTemporaryImage:(NSString *)imageResourceName
{
    if (([super initWith:useCache andUrl:url]))
    {
		imageView = [target retain];
		
		if (imageView != nil && imageResourceName != nil)
			imageView.image = [SnSImageUtils imageNamed:imageResourceName];
		
		activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		activity.center = CGPointMake(imageView.frame.size.width/2, imageView.frame.size.height/2);
		[activity startAnimating];

		[imageView addSubview:activity];

    }
        return self;
}

- (id) initAndEnqueueWith:(BOOL)useCache andTarget:(UIImageView *)target andUrl:(NSString *)url andTemporaryImage:(NSString *)imageResourceName
{
    if ([self initWith:useCache andTarget:target andUrl:url andTemporaryImage:imageResourceName])
	{
		// Only if the image URL is not null
		if (url != nil && [url length] > 0)
		{
			// Only if the image URL is not null
			[self enqueue:self];
		}

	}
	
        return self;
}


- (void)dealloc
{
	[imageView release];
	[activity release];
	
	[super dealloc];
}

- (void) onDataDownloaded:(NSData *)data
{
	if (data != nil)
	{
		UIImage * image = [[UIImage alloc] initWithData:data];
		if (imageView != nil && image != nil)
			imageView.image = image;
		
		// Release
		[image release];
	}
   	
	// Stop Activity
    [activity stopAnimating];
    [activity removeFromSuperview];
	
	
}

@end

@implementation SnSTableViewCellDownloadImageOperation

- (id) initWith:(BOOL)useCache andTarget:(UITableViewCell *)target andUrl:(NSString *)url andTemporaryImage:(NSString *)imageResourceName
{
    if (![super initWith:useCache andUrl:url])
    {
        return nil;
    }
    tableViewCell = target;
    if (tableViewCell != nil && imageResourceName != nil)
    {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 30000
        tableViewCell.image = [SnSImageUtils imageNamed:imageResourceName];
#else
        tableViewCell.imageView.image =  [SnSImageUtils imageNamed:imageResourceName];
#endif
    }
    return self;
}

- (id) initAndEnqueueWith:(BOOL)useCache andTarget:(UITableViewCell *)target andUrl:(NSString *)url andTemporaryImage:(NSString *)imageResourceName
{
    if (![super init])
    {
        return nil;
    }
    [self initWith:useCache andTarget:target andUrl:url andTemporaryImage:imageResourceName];
    if (url != nil && [url length] > 0)
    {
        // Only if the image URL is not null
        [self enqueue:self];
    }
    return self;
}

- (void) onDataDownloaded:(NSData *)data
{
    UIImage * image = [[UIImage alloc] initWithData:data];
    if (tableViewCell != nil)
    {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 30000
        tableViewCell.image = image;
#else
        tableViewCell.imageView.image = image;
#endif
    }
    //[((UITableView *) [tableViewCell superview]) reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone ];
}

@end
