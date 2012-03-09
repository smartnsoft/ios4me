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

- (void)storeData:(NSData *)iData forKey:(id)iKey
{
	// Dispatch the storing item into the cache queue
	dispatch_async(queue_, ^{
		SnSCacheItem* aItem = [SnSCacheItem itemWithKey:iKey data:iData];
		[self storeCacheItem:aItem forKey:iKey];
	});
	
}


- (void)storeCacheItem:(SnSCacheItem *)iItem forKey:(id)iKey
{
	// The application on the cache item is fairly simple on the memory cache
	// only add it to the items list
	@synchronized(items_)
		{ [items_ setObject:iItem forKey:iKey]; }
}

- (SnSCacheItem *)cachedItemForKey:(id)iKey update:(BOOL)iUpdate
{
	// add a lock on the accessed item and update it
	SnSCacheItem* aItem = [items_ objectForKey:iKey];
	
	if (iUpdate)
	{
		@synchronized(aItem)
		{
			aItem.hits += 1;
			aItem.lastAccessedDate = [NSDate date];
		}
	}
	
	return aItem;
}

- (NSData *)cachedDataForKey:(id)iKey
{
	SnSCacheItem* aItem = [self cachedItemForKey:iKey update:YES];
	
	return aItem.data;

}

- (NSArray*)purge
{
	NSInteger aTotalSizeKept = 0;
	
	// This purge method will be pretty simple.
	// Sort the keys by their value number of hits
	NSMutableArray* aSortedKeys = [NSMutableArray arrayWithArray:
								   [items_ keysSortedByValueUsingComparator:
									^NSComparisonResult(id obj1, id obj2) {
										SnSCacheItem* aItem1 = (SnSCacheItem*)obj1;
										SnSCacheItem* aItem2 = (SnSCacheItem*)obj2;
										
										
										// Reverse order, first item : maximum hits
										if (aItem1.hits > aItem2.hits)
											return NSOrderedAscending;
										else if (aItem1.hits < aItem2.hits)
											return NSOrderedDescending;
										
								return NSOrderedSame;
		
	}]];
	
	NSMutableArray* aKeysToKeep = [NSMutableArray arrayWithCapacity:[aSortedKeys count]];
	
	// now browse this sorted array of keys
	for (id aKey in aSortedKeys)
	{
		SnSCacheItem* aItem = [self cachedItemForKey:aKey];
		NSInteger aDataLength = [aItem.data length];
		
		// as long as the current capacity doesn't excess the low memory cap
		// keep adding the keys to keep
		if (aTotalSizeKept + aDataLength <= self.lowCapacity)
		{
			[aKeysToKeep addObject:aKey];
			aTotalSizeKept += aDataLength;
		}
		
		// othwersise, since the array is sorted stop right there
		else
			break;
	}
	
	// Update the cache size
	// (note that the property is atomic for thread safe reasons)
	self.cacheSize = aTotalSizeKept;
	
	// Finally remove all elements that were not part of the keys to keep
	NSInteger aLastIndex = [aKeysToKeep indexOfObject:[aKeysToKeep lastObject]];
	NSMutableArray* aRemovedKeys = [NSMutableArray arrayWithCapacity:[aSortedKeys count]];
	
	@synchronized(items_)
	{
		for (NSInteger i = aLastIndex; aLastIndex != NSNotFound && i < [aSortedKeys count]; ++i)
		{
			// Retrieve corresponding key
			id aKey = [aSortedKeys objectAtIndex:i];

			// Remove the associated value
			[items_ removeObjectForKey:aKey];
			
			// Add that key to the liset of removed oens
			[aRemovedKeys addObject:aKey];
		}
	}
	
	return aRemovedKeys;
	
	
}

- (void)purgeAll
{
	@synchronized(items_)
	{
		[items_ removeAllObjects];
	}
	
	self.cacheSize = 0;
}

#pragma mark -
#pragma mark SnSMemoryCache
#pragma mark -

- (void)storeString:(NSString *)iStr forKey:(id)iKey
{
	[self storeData:[iStr dataUsingEncoding:NSUTF8StringEncoding] forKey:iKey];
}



- (void)storeObject:(id)iObj forKey:(id)iKey
{
	if ([iObj isKindOfClass:[NSString class]])
		[self storeString:iObj forKey:iKey];
	else if ([iObj isKindOfClass:[NSData class]])
		[self storeData:iObj forKey:iKey];
}


@end
