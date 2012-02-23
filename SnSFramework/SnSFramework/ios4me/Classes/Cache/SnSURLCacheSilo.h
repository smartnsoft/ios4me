//
//  SnSURLCacheSilo.h
//  SnSFramework
//
//  Created by Johan Attali on 7/27/11.
//  Copyright 2011 Smart&Soft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SnSCacheSilo.h"
#import "SnSCacheDelegate.h"
/**
 *	This class overrides some of the default SnSCacheBehaviour to match
 *	the behaviour of real URL cache and therefore downloads the content if needed.
 */
@interface SnSURLCacheSilo : SnSCacheSilo 
{
    id<SnSCacheConnectionHandler> _connectionHandler;
}

/**
 *	The object responsible for handling the connection.
 *	If not provided the default behaviour will occur.
 */

@property (nonatomic, retain) id<SnSCacheConnectionHandler> connectionHandler;

/**
 *	Creates the request for the given URL and fetches the content.
 *
 *	Note that the content is fetched synchronously, that means the thread
 *	on which the request is made will block until the content is fetched or
 *	timeout is received.
 *
 *	To overcome this issue, use the cache in an async manner.
 *
 *	@param	iURL	The url to fetch
 *	@return	The data associated with that URL
 */
- (NSData*)dataForRequest:(NSURLRequest*)iURL;

@end
