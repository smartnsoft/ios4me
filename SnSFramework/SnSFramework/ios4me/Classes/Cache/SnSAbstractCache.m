//
//  SnSURLCacheSilo.m
//  SnSFramework
//
//  Created by Johan Attali on 26/07/11.
//  Copyright 2011 Smart&Soft. All rights reserved.
//

#import "SnSAbstractCache.h"

#import "SnSUtils.h"
#import "SnSCacheException.h"

@implementation SnSAbstractCache

#pragma mark - Properties

@synthesize highCapacity = highCapacity_;
@synthesize lowCapacity = lowCapacity_;
@synthesize items = _items;

static NSInteger sCacheIndex = -1;

//#pragma mark - Singleton Methods
//
//+ (SnSURLCacheSilo*)instance
//{
//    static SnSURLCacheSilo* aSingleton = nil;
//    
//    if (aSingleton == nil)
//        aSingleton = [[SnSURLCacheSilo alloc] init];
//    
//    return aSingleton;
//}

#define kSnSCacheSiloHighCapacityKey @"highCapacity"
#define kSnSCacheSiloLowCapacityKey @"lowCapacity"
#define kSnSCacheSiloCacheIndexKey @"cacheIndex"
#define kSnSCacheSiloItemsKey @"items"
#define kSnSCacheSiloMemoryKey @"memory"

#pragma mark - Init Methods

- (id)initWithMaxCapacity:(NSInteger)iHighCapacity
			  minCapacity:(NSInteger)iLowCapacity
{
    if ((self = [super init]))
    {
        highCapacity_ = iHighCapacity;
        lowCapacity_ = iLowCapacity;
        

		/* ***  Computed Values *** */
		cacheIndex_ = ++sCacheIndex;
				
        items_ = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)dealloc
{
	@synchronized(items_)
	{
		[items_ release];
		items_ = nil;
	}
	
    [super dealloc];
    
}

- (NSString*)description
{
	return [NSString stringWithFormat:@"id: %u - items [%d] - high: %d - low: %d", cacheIndex_, [items_ count], highCapacity_, lowCapacity_];
}

#pragma mark - NSCoding Methods

- (void)encodeWithCoder:(NSCoder *)aCoder
{
	SnSLogD(@"Encoding Cache [%@] ", self);
	
	// Integers
	[aCoder encodeInteger:highCapacity_ forKey:kSnSCacheSiloHighCapacityKey];
	[aCoder encodeInteger:lowCapacity_ forKey:kSnSCacheSiloLowCapacityKey];
	[aCoder encodeInteger:cacheIndex_ forKey:kSnSCacheSiloCacheIndexKey];


	// Objects
	[aCoder encodeObject:items_ forKey:kSnSCacheSiloItemsKey];

}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if ((self = [super init]))
	{
		highCapacity_		= [aDecoder decodeIntegerForKey:kSnSCacheSiloHighCapacityKey];
		lowCapacity_		= [aDecoder decodeIntegerForKey:kSnSCacheSiloLowCapacityKey];
		cacheIndex_			= [aDecoder decodeIntegerForKey:kSnSCacheSiloCacheIndexKey];

		items_				= [[aDecoder decodeObjectForKey:kSnSCacheSiloItemsKey] retain];
		
		sCacheIndex = MAX(cacheIndex_, sCacheIndex);
	}
	
	SnSLogD(@"Decoded Cache [%@] ", self);
	
	return self;
}


#pragma mark Store/Retrieve data from cache

- (void)storeCacheItem:(SnSCacheItem*)iItem forKey:(id)iKey
{
	SnSLogW(@"This method will do nothing and should be overwritten in your custom %@ class", [self class]);
}

- (void)storeObject:(id)iObject forKey:(id)iKey
{
	SnSLogW(@"This method will do nothing and should be overwritten in your custom %@ class", [self class]);
}


- (SnSCacheItem*)cachedItemForKey:(id)iKey
{
	SnSLogW(@"This method will return nil and should be overwritten in your custom %@ class", [self class]);
	
	return nil;
}

- (id)cachedObjectForKey:(id)iKey
{
	SnSLogW(@"This method will return nil and should be overwritten in your custom %@ class", [self class]);
	
	return nil;
}



			 



@end
