//
//  SnSRemoteServices.h
//  ios4me
//
//  Created by Johan Attali on 06/03/12.
//  Copyright (c) 2012 Smart&Soft. All rights reserved.
//

#import "SnSSingleton.h"
#import "SnSLoadingView.h"

#import "SnSWebServiceCaller.h"

@class ASIHTTPRequest;
@class SnSMemoryCache;

typedef void (^SnSImageCompletionBlock)(UIImage*);
typedef void (^SnSImageErrorBlock)(NSError*);

typedef enum SnSImageRetrievalOption
{
	kSnSImageRetrievalOptionNone				= 0x0,
	kSnSImageRetrievalOptionDoNotCancelRequest	= 0x0001,
	kSnSImageRetrievalOptionResizeURL			= 0x0010,
	kSnSImageRetrievalOptionResizeToBinding		= 0x0100,
	kSnSImageRetrievalOptionImageCrossFade		= 0x1000,
}SnSImageRetrievalOption;


/** 
 * @interface SnSRemoteServices
 * Your application main services class should always inherit this class
 * to have prebuilt behaviour pre loaded such as asynchronous image downloading.
 */

@interface SnSRemoteServices : SnSWebServiceCaller
{
	@protected
	NSMutableDictionary* requests_;		//<! The dictionary holding 'binding' -> 'requests'
    SnSMemoryCache* cache_;             //<! The memory cache to use if any
}
@property (nonatomic, readonly) NSMutableDictionary* requests; //<! The dictionary holding 'url' -> 'requests'
@property (nonatomic, retain)   SnSMemoryCache* cache; //<! The memory cache to use if any

#pragma mark Preparation

/**
 *	Override this default behaviour method to customize the request headers
 *	or caching properties.
 *	@param	iRequest		The request that need preparation
 */
- (void)prepareImageRequest:(ASIHTTPRequest*)iRequest;

/**
 *	Override this default behaviour method to customize string format that is used
 *	to resize the images that have been passed the kSnSImageRetrievalOptionResizeURL option .
 *	@return	An formatted to accept the width and height
 */
- (NSURL*)urlForResizingServices:(NSURL*)iImageURL binding:(UIImageView*)iBindingView;

#pragma mark Image Retrieval

/**
 *	Retrieve an image given its target url and binds it to the image view passed in paramater
 *	Also, if a loading view is given, starts animating it stops it when the image is downloaded
 *	@param	iURL				The URL to retreive the image from
 *	@param	iBindingView		The view responsible for binding when the image is done downloading
 *	@param	iLoadingView		Optional. The loading view that will be automatically started stopped.
 *	@param	iCompletionBlock	Optional. The block executed once the image has been retrieved
 *	@param	iErrorBlock			Optional. The block executed when an error occured
 */
- (void)retrieveImageURL:(NSURL*)iURL binding:(UIView*)iBindingView indicator:(UIView*)iLoadingView;

- (void)retrieveImageURL:(NSURL*)iURL 
				 binding:(UIView*)iBindingView 
			   indicator:(UIView*)iLoadingView 
				  option:(SnSImageRetrievalOption)iOption;

- (void)retrieveImageURL:(NSURL*)iURL 
				 binding:(UIView*)iBindingView 
			   indicator:(UIView*)iLoadingView 
		 completionBlock:(SnSImageCompletionBlock)iBlock
			  errorBlock:(SnSImageErrorBlock)iBlock;

- (void)retrieveImageURL:(NSURL*)iURL 
				 binding:(UIView*)iBindingView 
			   indicator:(UIView*)iLoadingView 
				  option:(SnSImageRetrievalOption)iOption
		 completionBlock:(SnSImageCompletionBlock)iBlock
			  errorBlock:(SnSImageErrorBlock)iBlock;

/**
 *	Returns YES if the URL passed in parameter is already cached either by the memory cache or by
 *	the file system cache.
 *	@return	YES if already cached no otherwise
 */
- (BOOL)isCachedImageURL:(NSURL*)iURL;



@end
