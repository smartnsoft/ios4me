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
//  SnSMemoryCache.m
//  SnSFramework
//
//  Created by Édouard Mercier on 10/24/2009.
//

#import "SnSMemoryCache.h"
#import "SnSCacheItem.h"

@implementation SnSMemoryCache

#pragma mark -
#pragma mark SnSAbstractCache
#pragma mark -

- (void)storeObject:(id)iObj forKey:(id)iKey
{
	if ([iObj isKindOfClass:[NSString class]])
		[self storeString:iObj forKey:iKey];
	else if ([iObj isKindOfClass:[NSData class]])
		[self storeData:iObj forKey:iKey];
}

- (void)storeCacheItem:(SnSCacheItem *)iItem forKey:(id)iKey
{
	// The application on the cache item is fairly simple on the memory cache
	// only add it to the items list
	@synchronized(items_)
		{ [items_ setObject:iItem forKey:iKey]; }
}

- (SnSCacheItem *)cachedItemForKey:(id)iKey
{
	// simply return the value stored in the dictionary 
	return [items_ objectForKey:iKey];
}

#pragma mark -
#pragma mark SnSMemoryCache
#pragma mark -

- (void)storeString:(NSString *)iStr forKey:(id)iKey
{
	[self storeData:[iStr dataUsingEncoding:NSUTF8StringEncoding] forKey:iKey];
}

- (void)storeData:(NSData *)iData forKey:(id)iKey
{
	// Dispatch the storing item into the cache queue
	dispatch_async(queue_, ^{
		SnSCacheItem* aItem = [SnSCacheItem itemWithKey:iKey data:iData];
		[self storeCacheItem:aItem forKey:iKey];
	});
	
}



@end
