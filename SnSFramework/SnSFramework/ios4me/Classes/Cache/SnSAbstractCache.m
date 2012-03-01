//
//  SnSURLAbstractCache.m
//  SnSFramework
//
//  Created by Johan Attali on 26/07/11.
//  Copyright 2011 Smart&Soft. All rights reserved.
//

#import "SnSAbstractCache.h"
#import "SnSCacheChecker.h"

#import "SnSUtils.h"

@implementation SnSAbstractCache

#pragma mark - Properties

@synthesize highCapacity = highCapacity_;
@synthesize lowCapacity = lowCapacity_;
@synthesize cacheSize = cacheSize_;
@synthesize items = items_;

static NSInteger sCacheIndex = -1;

#define kSnSAbstractCacheHighCapacityKey @"highCapacity"
#define kSnSAbstractCacheLowCapacityKey @"lowCapacity"
#define kSnSAbstractCacheCacheIndexKey @"cacheIndex"
#define kSnSAbstractCacheItemsKey @"items"

#define kSnSAbstractCacheDefaultHighCapacity 1024*1024*3	// 3 Megabytes
#define kSnSAbstractCacheDefaultLowCapacity 1024*300		// 300 Kilobytes

#pragma mark -
#pragma mark NSObject
#pragma mark -

- (id)init
{
	return [self initWithMaxCapacity:kSnSAbstractCacheDefaultHighCapacity 
						 minCapacity:kSnSAbstractCacheDefaultLowCapacity];
}

/** 
 *	Designated Initalizer
 */
- (id)initWithMaxCapacity:(NSInteger)iHighCapacity
			  minCapacity:(NSInteger)iLowCapacity
{
    if ((self = [super init]))
    {
		//------------------------------------
		// Propery Vars
		//------------------------------------
        highCapacity_ = iHighCapacity;
        lowCapacity_ = iLowCapacity;
        

		//------------------------------------
		// Default Values
		//------------------------------------
		cacheIndex_ = ++sCacheIndex;
		cacheSize_ = 0;
				
        items_ = [[NSMutableDictionary alloc] init];
		
		//------------------------------------
		// Cache Checker
		//------------------------------------
		[[SnSCacheChecker instance] addCache:self];
    }
    return self;
}

- (void)dealloc
{
	@synchronized(items_)
		{ SnSReleaseAndNil(items_); }
	
    [super dealloc];
    
}

- (NSString*)description
{
	return [NSString stringWithFormat:@"id: %u - size: %d - items [%d] - high: %d - low: %d", 
			cacheIndex_, 
			cacheSize_,
			[items_ count],
			highCapacity_,
			lowCapacity_];
}

#pragma mark -
#pragma mark NSCoding Methods
#pragma mark -

- (void)encodeWithCoder:(NSCoder *)aCoder
{
	SnSLogD(@"Encoding Cache [%@] ", self);
	
	// Integers
	[aCoder encodeInteger:highCapacity_ forKey:kSnSAbstractCacheHighCapacityKey];
	[aCoder encodeInteger:lowCapacity_ forKey:kSnSAbstractCacheLowCapacityKey];
	[aCoder encodeInteger:cacheIndex_ forKey:kSnSAbstractCacheCacheIndexKey];

	// Objects
	[aCoder encodeObject:items_ forKey:kSnSAbstractCacheItemsKey];

}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if ((self = [super init]))
	{
		highCapacity_		= [aDecoder decodeIntegerForKey:kSnSAbstractCacheHighCapacityKey];
		lowCapacity_		= [aDecoder decodeIntegerForKey:kSnSAbstractCacheLowCapacityKey];
		cacheIndex_			= [aDecoder decodeIntegerForKey:kSnSAbstractCacheCacheIndexKey];

		items_				= [[aDecoder decodeObjectForKey:kSnSAbstractCacheItemsKey] retain];
		
		sCacheIndex = MAX(cacheIndex_, sCacheIndex);
	}
	
	SnSLogD(@"Decoded Cache [%@] ", self);
	
	return self;
}


#pragma mark -
#pragma mark Store/Retrieve data from cache
#pragma mark -

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
