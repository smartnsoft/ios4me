//
//  SnSURLCacheSilo.m
//  SnSFramework
//
//  Created by Johan Attali on 26/07/11.
//  Copyright 2011 Smart&Soft. All rights reserved.
//

#import "SnSCacheSilo.h"

#import "SnSUtils.h"
#import "SnSCacheException.h"

@implementation SnSCacheSilo

#pragma mark - Properties

@synthesize memoryCapacity = _memoryCapacity;
@synthesize diskCapacity = _diskCapacity;
@synthesize diskPath = _diskPath;
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

#define kSnSCacheSiloMemCapacityKey @"memoryCapacity"
#define kSnSCacheSiloDiskCapacityKey @"diskCapacity"
#define kSnSCacheSiloCacheIndexKey @"cacheIndex"
#define kSnSCacheSiloItemsKey @"items"
#define kSnSCacheSiloMemoryKey @"memory"

#pragma mark - Init Methods

- (id)initWithMemoryCapacity:(NSInteger)iMemoryCapacity
				diskCapacity:(NSInteger)iDiskCapacity
{
    if ((self = [super init]))
    {
        _memoryCapacity = iMemoryCapacity;
        _diskCapacity = iDiskCapacity;
        

		/* ***  Computed Values *** */
		
		_cacheIndex = ++sCacheIndex;
		
		// The disk path will hold the content of the cache when it's saved
        _diskPath = [[NSString alloc] initWithFormat:@"%@/Caches/%@-%d/", [SnSUtils applicationCachesPath], kSnSCacheName, _cacheIndex];
		
        _items = [[NSMutableDictionary alloc] init];
		_memory = [[NSMutableDictionary alloc] initWithCapacity:iMemoryCapacity];
		
		[self createCacheFolderIfNeeded];
    }
    return self;
}

- (void)dealloc
{
    [_diskPath release];
    [_items release];
    [_memory release];
	
    [super dealloc];
    
}

- (NSString*)description
{
	return [NSString stringWithFormat:@"id: %u - items: %d - mem: %d - disk: %d", _cacheIndex, [_items count], _memoryCapacity, _diskCapacity];
}

#pragma mark - NSCoding Methods

- (void)encodeWithCoder:(NSCoder *)aCoder
{
	SnSLogD(@"Encoding Cache [%@] ", self);
	
	// Integers
	[aCoder encodeInteger:_memoryCapacity forKey:kSnSCacheSiloMemCapacityKey];
	[aCoder encodeInteger:_diskCapacity forKey:kSnSCacheSiloDiskCapacityKey];
	[aCoder encodeInteger:_cacheIndex forKey:kSnSCacheSiloCacheIndexKey];


	// Objects
	[aCoder encodeObject:_items forKey:kSnSCacheSiloItemsKey];
	[aCoder encodeObject:_memory forKey:kSnSCacheSiloMemoryKey];

}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if ((self = [super init]))
	{
		_memoryCapacity		= [aDecoder decodeIntegerForKey:kSnSCacheSiloMemCapacityKey];
		_diskCapacity		= [aDecoder decodeIntegerForKey:kSnSCacheSiloDiskCapacityKey];
		_cacheIndex			= [aDecoder decodeIntegerForKey:kSnSCacheSiloCacheIndexKey];

		
		_items				= [[aDecoder decodeObjectForKey:kSnSCacheSiloItemsKey] retain];
		_memory				= [[aDecoder decodeObjectForKey:kSnSCacheSiloMemoryKey] retain];
		
		_diskPath			= [[NSString alloc] initWithFormat:@"%@/Caches/%@-%d/", [SnSUtils applicationCachesPath], kSnSCacheName, _cacheIndex];
		
		sCacheIndex = MAX(_cacheIndex, sCacheIndex);
	}
	
	SnSLogD(@"Decoded Cache [%@] ", self);
	
	return self;
}

#pragma mark Cache Creation/Removal

- (void)createCacheFolderIfNeeded
{
	NSFileManager *aManager = [NSFileManager defaultManager];
    NSError *aError = nil;
	BOOL aIsDir = NO;
	
	if (![aManager fileExistsAtPath:_diskPath isDirectory:&aIsDir])
		[aManager createDirectoryAtPath:_diskPath withIntermediateDirectories:YES attributes:nil error:&aError];
	
	if (aError != nil)
	{
		SnSCacheError* aCacheError = [SnSCacheError errorWithCode:SnSCacheErrorCacheCreateFailed 
											 localizedDescription:[aError localizedDescription]];
		
		[[SnSCacheException exceptionWithError:aCacheError] raise];
	}
	
}

- (void)removeCacheFolder
{
	// Flush dictionary
	[_items removeAllObjects];
	
	NSError* aError = nil;
	[[NSFileManager defaultManager] removeItemAtPath:_diskPath error:&aError];
	
	if (aError)
	{
		SnSCacheError* aCacheError = [SnSCacheError errorWithCode:SnSCacheErrorArchiveFailed 
											 localizedDescription:[aError localizedDescription]];
		
		[[SnSCacheException exceptionWithError:aCacheError] raise];
		
	}
}

- (void)removeAllCachedItems
{
    [_items removeAllObjects];
}

#pragma mark Store/Retrieve data from cache

- (void)storeCacheItem:(SnSCacheItem*)iItem forKey:(id)iKey
{
	// First item added ? => store key class type
	if ([_items count] == 0)
		_keyClass = [iKey class];
	
	// Key Class different that what is already stored ? => Raise exception
	else if (![iKey isKindOfClass:_keyClass])
		SnSLogE(@"The requested key: %@ is not of the expected cache class: %@", iKey, _keyClass);
	
	// Generate cache item path
//	NSString* aPath = [self uniquePathNameForKey:iKey];
	
	// override whatever was used for the key
	//[_items setObject:aPath forKey:iKey];
	
	// and write item to disk
	[self archiveCacheItem:iItem path:[self infoPathForKey:iKey]];
}

- (SnSCacheItem*)cachedItemForKey:(id)iKey
{
	SnSCacheItem* aItem = nil;
	
	// First look into memory item
	aItem = [_memory objectForKey:iKey];
	
	// Not found then is it the disk
	if (!aItem)
	{
		NSString* aPath = [self infoPathForKey:iKey];
		if (aPath)
			aItem = [self unarchiveCacheItemAtPath:aPath];
	}
	
	return aItem;
}

- (NSData*)cachedDataForKey:(id)iKey
{
	NSString* aDataPath = [self dataPathForKey:iKey];
	return [NSData dataWithContentsOfFile:aDataPath];
}

- (void)storeData:(NSData *)iData forKey:(id)iKey
{
	NSString* aDataPath = [self dataPathForKey:iKey];
	[iData writeToFile:aDataPath atomically:NO];
}

#pragma mark - Disk Accesss Methods

- (NSString *)infoPathForKey:(id)iKey
{
	return [[self uniquePathNameForKey:iKey] stringByAppendingString:@".info"];

}
- (NSString *)dataPathForKey:(id)iKey
{
	return [[self uniquePathNameForKey:iKey] stringByAppendingString:@".data"];
}

- (NSString*)uniquePathNameForKey:(id)iKey
{
	NSString* aUniqueValue = [_items objectForKey:iKey];
	if (!aUniqueValue)
	{
		aUniqueValue = [_diskPath stringByAppendingFormat:@"%@", [NSString stringUnique]];
		[_items setObject:aUniqueValue forKey:iKey];
	}
	return aUniqueValue;
}

#pragma mark - Archive/Unarchive Methods
					   
- (void)archiveCacheItem:(SnSCacheItem*)iItem path:(NSString*)iPath
{
	
	if (![NSKeyedArchiver archiveRootObject:iItem toFile:iPath])
	{
		SnSCacheError* aCacheError = [SnSCacheError errorWithCode:SnSCacheErrorArchiveFailed 
										localizedDescription:[NSString stringWithFormat:@"Failed to write item: %@ at path %@", iItem, iPath]];
		
		[[SnSCacheException exceptionWithError:aCacheError] raise];
	}
}

- (SnSCacheItem*)unarchiveCacheItemAtPath:(NSString*)iPath
{
	SnSCacheItem* aItem = [NSKeyedUnarchiver unarchiveObjectWithFile:iPath];
	
	if (!aItem)
	{
		SnSCacheError* aCacheError = [SnSCacheError errorWithCode:SnSCacheErrorUnarchiveFailed
											 localizedDescription:[NSString stringWithFormat:@"Failed to retreive item at path %@", iPath]];
		
		[[SnSCacheException exceptionWithError:aCacheError] raise];
	}
	return aItem;
}

- (void)archive
{
	NSString* aPath = [_diskPath stringByAppendingFormat:@"/%@.plist", kSnSCacheName, _cacheIndex];
	if (![NSKeyedArchiver archiveRootObject:self toFile:aPath])
	{
		SnSCacheError* aCacheError = [SnSCacheError errorWithCode:SnSCacheErrorArchiveFailed 
											 localizedDescription:[NSString stringWithFormat:@"Failed to write cache: %@ at path %@", self, aPath]];
		
		[[SnSCacheException exceptionWithError:aCacheError] raise];

	}
	
}

+ (id)cacheUnarchivedFromPath:(NSString*)iPath
{
	SnSCacheSilo* aCache = [NSKeyedUnarchiver unarchiveObjectWithFile:iPath];
	
	if (!aCache)
	{
		SnSCacheError* aCacheError = [SnSCacheError errorWithCode:SnSCacheErrorUnarchiveFailed
											 localizedDescription:[NSString stringWithFormat:@"Failed to retreive cache at path %@", iPath]];
		
		[[SnSCacheException exceptionWithError:aCacheError] raise];
	}
	
	return aCache;

}
			 



@end
