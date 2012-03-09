//
//  SnSRemoteServices.h
//  ios4me
//
//  Created by Johan Attali on 06/03/12.
//  Copyright (c) 2012 Smart&Soft. All rights reserved.
//

#import "SnSSingleton.h"
#import "SnSLoadingView.h"

@class ASIHTTPRequest;

typedef void (^SnSImageCompletionBlock)(UIImage*);
typedef void (^SnSImageErrorBlock)(NSError*);


/** 
 * @interface SnSRemoteServices
 * Your application main services class should always inherit this class
 * to have prebuilt behaviour pre loaded such as asynchronous image downloading.
 */

@interface SnSRemoteServices : SnSSingleton
{
	@protected
	NSMutableDictionary* requests_;		//<! The dictionary holding 'binding' -> 'requests'
}
@property (nonatomic, readonly) NSMutableDictionary* requests; //<! The dictionary holding 'url' -> 'requests'

#pragma mark Preparation

/**
 *	Override this default behaviour method to customize the request headers
 *	or caching properties.
 *	@param	iRequest		The request that need preparation
 */
- (void)prepareRequest:(ASIHTTPRequest*)iRequest;

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
- (void)retrieveImageURL:(NSURL*)iURL binding:(UIImageView*)iBindingView indicator:(UIView*)iLoadingView;

- (void)retrieveImageURL:(NSURL*)iURL 
				 binding:(UIImageView*)iBindingView 
			   indicator:(UIView*)iLoadingView 
		 completionBlock:(SnSImageCompletionBlock)iBlock
			  errorBlock:(SnSImageErrorBlock)iBlock;

@end
