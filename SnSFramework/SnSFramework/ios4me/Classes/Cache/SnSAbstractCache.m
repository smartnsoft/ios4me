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
	return [self initWithMaxCapacity:[self highCapacity]
						 minCapacity:[self lowCapacity]];
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
		queue_ = dispatch_queue_create( "com.smartnsoft.cache", NULL );
		
		//------------------------------------
		// Cache Checker
		//------------------------------------
		[[SnSCacheChecker instance] addCache:self];
    }
    return self;
}

- (void)dealloc
{
	[items_ release];
	
	dispatch_release(queue_);
	
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

#pragma mark Cache Size


- (NSInteger)highCapacity
{
    return kSnSAbstractCacheDefaultHighCapacity;
}

- (NSInteger)lowCapacity
{
    return kSnSAbstractCacheDefaultLowCapacity;
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

- (void)storeData:(NSData*)iData forKey:(id)iKey
{
	SnSLogW(@"This method will do nothing and should be overwritten in your custom %@ class", [self class]);
}

- (SnSCacheItem*)cachedItemForKey:(id)iKey
{
	return [self cachedItemForKey:iKey update:NO];
}

- (SnSCacheItem*)cachedItemForKey:(id)iKey update:(BOOL)iUpdate
{
	SnSLogW(@"This method will return nil and should be overwritten in your custom %@ class", [self class]);
	
	return nil;
}


- (NSData*)cachedDataForKey:(id)iKey
{
	SnSLogW(@"This method will return nil and should be overwritten in your custom %@ class", [self class]);
	
	return nil;
}

#pragma mark -
#pragma mark Purge Cache
#pragma mark -

- (NSArray*)purge
{
	SnSLogW(@"This method will return nil and should be overwritten in your custom %@ class", [self class]);
	return nil;
}

- (void)purgeAll
{
	SnSLogW(@"This method will do nothing and should be overwritten in your custom %@ class", [self class]);
}

			 



@end
