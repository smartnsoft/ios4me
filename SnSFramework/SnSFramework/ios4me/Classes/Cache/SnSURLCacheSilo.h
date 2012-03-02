/*
 * (C) Copyright 2009-2011 Smart&Soft SAS (http://www.smartnsoft.com/) and contributors.
 *
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the GNU Lesser General Public License
 * (LGPL) version 3.0 which accompanies this distribution, and is available at
 * http://www.gnu.org/licenses/lgpl.html
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * Lesser General Public License for more details.
 *
 * Contributors:
 *     Smart&Soft - initial API and implementation
 */

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
