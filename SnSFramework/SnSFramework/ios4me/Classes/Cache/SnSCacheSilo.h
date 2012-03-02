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

#import "SnSSingleton.h"

@class SnSCacheItem;

#define kSnSCacheName @"SnSCache"

@interface SnSCacheSilo : NSObject <NSCoding>
{
    NSInteger   _memoryCapacity;
    NSInteger   _diskCapacity;
    NSString*   _diskPath;
    
    NSMutableDictionary* _items;
	NSMutableDictionary* _memory;
	
	Class _keyClass;
    
    @protected
    NSInteger   _cacheIndex;
}

@property (nonatomic) NSInteger memoryCapacity;
@property (nonatomic) NSInteger diskCapacity;
@property (nonatomic,readonly) NSString* diskPath;

/**
 *  Key:    <url>
 *  Value:  <SnSURLCacheItem>
 */
@property (nonatomic,readonly) NSMutableDictionary* items;

#pragma mark Cache Creation/Removal

/**
 *  Creates the cache with its memory and disk capacity
 *	@param	iMemoryCapacity The maximum size of the cache used in memory in bytes
 *	@param	iDiskCapacity	The maximum size of the cache used in disk in bytes
 */
- (id)initWithMemoryCapacity:(NSInteger)iMemoryCapacity
				diskCapacity:(NSInteger)iDiskCapacity;

/**
 *  Removes all items from the cache. 
 *	Note that this doesn't release the items object. It only removes all its content.
 */
- (void)removeAllCachedItems;

/**
 *	Removes the entire cache and its data
 */
- (void)removeCacheFolder;

/**
 *  Useful at first launch of an application 
 *	This creates the cache folder where the content will be stored if that folder
 *	is not already created
 */
- (void)createCacheFolderIfNeeded;

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
 */
- (SnSCacheItem*)cachedItemForKey:(id)iKey;

/**
 *  Retreives the cached data for a given key.
 * @param iKey	
 *	The key that will be used to retreive the corresponding item.
 * @return
 *	The data associated to given key if found, nil otherwise
 */
- (NSData*)cachedDataForKey:(id)iKey;



#pragma mark - Archive/Unarchive Methods

/**
 *  Uses an NSKeyedArchiver to write an item into a specified file
 *	@param	iItem	The cache item to store
 *	@param	iPath	The path where the item is to be written
 */
- (void)archiveCacheItem:(SnSCacheItem*)iItem path:(NSString*)iPath;

/**
 *  Uses an NSKeyedArchiver to write an item into a specified file
 *	@param	iPath	The path where the item is to be read
 *	@param	The item built from read the file at specified path
 */
- (SnSCacheItem*)unarchiveCacheItemAtPath:(NSString*)iPath;

/**
 *	Saves the cache into a readable object for future load
 */
- (void)archive;

/**
 *	Reloads the cache from disk
 */
+ (id)cacheUnarchivedFromPath:(NSString*)iPath;

#pragma mark - Disk Accesss Methods

/**
 *  Generates a unique path for a given item
 *	@param	iKey	The cache key to store
 *	@return	A unique path made of the cache silo path and a unique string in UUID format
 */
- (NSString*)uniquePathNameForKey:(id)iKey;

/**
 *  Returns the data path associated to a given key
 *	@param	iKey	The cache key to store
 *	@return	A unique path made of the cache silo path and a unique string in UUID format
 */
- (NSString*)dataPathForKey:(id)iKey; 

/**
 *  Returns the information (date, hits...) path associated to a given key
 *	@param	iKey	The cache key to store
 *	@return	A unique path made of the cache silo path and a unique string in UUID format
 */
- (NSString*)infoPathForKey:(id)iKey; 

@end

