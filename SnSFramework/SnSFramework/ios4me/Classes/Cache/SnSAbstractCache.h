//
//  SnSURLCacheSilo.h
//  SnSFramework
//
//  Created by Johan Attali on 26/07/11.
//  Copyright 2011 Smart&Soft. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SnSSingleton.h"

@class SnSCacheItem;

/**
 *	The SnSAbstractCache inherits from the SnSSingleton class but it
 *	doesn't have to be used as a singleton.
 *	You can safely add more caches to your application using the designated initalizer.
 */
@interface SnSAbstractCache : SnSSingleton <NSCoding>
{
    NSInteger   highCapacity_;
    NSInteger   lowCapacity_;
    
    NSMutableDictionary* items_;
    
    @protected
    NSInteger   cacheIndex_;
	NSInteger	cacheSize_;		//<! The cache size is calculated in the background by the SnSCacheChecker
	dispatch_queue_t queue_;	//<! The cache GCD queue used for read and write operations
}

@property (nonatomic) NSInteger highCapacity;
@property (nonatomic) NSInteger lowCapacity;
@property (assign) NSInteger cacheSize;

/**
 *  Key:    <url>
 *  Value:  <SnSURLCacheItem>
 */
@property (nonatomic,readonly) NSMutableDictionary* items;

#pragma mark Cache Creation/Removal

/**
 *	Designated Initalizer.
 *  Creates the cache with its high and low capacity.
 *	The high value means that beyound that point, the SnSCacheChecker will purge it
 *	while the low value is how much is kept during purge.
 *	@param	iHighCapacity	The maximum size of the cache used in memory in bytes
 *	@param	iLowCapacity	The minimum size of the cache kept during purge
 */
- (id)initWithMaxCapacity:(NSInteger)iHighCapacity
			  minCapacity:(NSInteger)iLowCapacity;


#pragma mark Store/Retrieve data from cache

/**
 *  This method overrides whatever was stored for the given key
 *	with the new item passed in parameter.
 *	@param	iItem	The new item fetched
 *	@param	iKey	The key used to store/retreive the cached object
 */
- (void)storeCacheItem:(SnSCacheItem*)iItem forKey:(id)iKey;

/**
 *  This method overrides whatever data was stored for the given key
 *	with the new item passed in parameter.
 *	@param	iData	The data associated to the key that we want to store
 *	@param	iKey	The key used to store/retreive the cached object
 */
- (void)storeData:(NSData*)iData forKey:(id)iKey;


/**
 *  Retreives the cached item given its key.
 *	@param iKey	The key that will be used to retreive the corresponding item.
 *  @param  iUpdate	A boolean that tells if the cache item should be updated or no (default is NO).
 */
- (SnSCacheItem*)cachedItemForKey:(id)iKey;
- (SnSCacheItem*)cachedItemForKey:(id)iKey update:(BOOL)iUpdate;

/**
 *  Retreives the cached data for a given key.
 * @param iKey	
 *	The key that will be used to retreive the corresponding item.
 * @return
 *	The object associated to given key if found, nil otherwise
 */
- (NSData*)cachedDataForKey:(id)iKey;


#pragma mark Purge Cache

- (void)purge;


@end

