//
//  SnSMasterCache.m
//  SnSFramework
//
//  Created by Johan Attali on 01/08/11.
//  Copyright 2011 Smart&Soft. All rights reserved.
//

#import "SnSMasterCache.h"
#import "SnSCacheItem.h"
#import "SnSCacheException.h"
#import "SnSCacheSilo.h"

#define kSnSMasterCacheCachesKey @"caches"

@implementation SnSMasterCache

@synthesize caches = _caches;

#pragma mark - Init Methods

- (id)init
{
	// If the master cache has been saved, restore it
	NSString* aMasterCachePath = [SnSMasterCache masterCachePath];
	NSFileManager* aManager = [NSFileManager defaultManager];
	if ([aManager fileExistsAtPath:aMasterCachePath])
		self = [[SnSMasterCache unarchive:aMasterCachePath] retain];
	else
	{
		if ((self = [super init]))
		{
			_caches = [[NSMutableDictionary alloc] init];
		}
	}

	
	return  self;
}

- (void)dealloc
{
	[_caches release];
	
	[super dealloc];
}

#pragma mark - NSCoding Methods

- (void)encodeWithCoder:(NSCoder *)aCoder
{
	SnSLogD(@"Encoding Cache [%@] ", self);
	
	[aCoder encodeObject:_caches forKey:kSnSMasterCacheCachesKey];
}
 
- (id)initWithCoder:(NSCoder *)aDecoder
{
	if ((self = [super init]))
	{
		_caches	= [[aDecoder decodeObjectForKey:kSnSMasterCacheCachesKey] retain];
	}
	
	SnSLogD(@"Decoded Cache [%@] ", self);
	
	return self;

}

#pragma mark - Archive/Unarchive Methods

- (void)archive
{
	@synchronized(self)
	{
		// Archive master cache
		NSString* aPath = [SnSMasterCache masterCachePath];
		
		SnSLogD(@"Archiving %@ at path: %@", self.class, aPath);
		
		if (![NSKeyedArchiver archiveRootObject:self toFile:aPath])
		{
			SnSCacheError* aCacheError = [SnSCacheError errorWithCode:SnSCacheErrorArchiveFailed 
												 localizedDescription:[NSString stringWithFormat:@"Failed to write Master Cache at pathh %@", aPath]];
			
			[[SnSCacheException exceptionWithError:aCacheError] raise];
			
		}
		
		for (SnSCacheSilo* aSilo in [_caches allValues])
			[aSilo archive];
	}
}

+ (id)unarchive:(NSString*)iPath
{
	SnSLogD(@"Restoring %@ at path: %@",self.class, iPath);
	
	SnSMasterCache* aMasterCache  = [NSKeyedUnarchiver unarchiveObjectWithFile:iPath];
	if (!aMasterCache)
	{
		SnSCacheError* aCacheError = [SnSCacheError errorWithCode:SnSCacheErrorUnarchiveFailed
											 localizedDescription:[NSString stringWithFormat:@"Failed to restore master cache at path %@", iPath]];
		
		[[SnSCacheException exceptionWithError:aCacheError] raise];
	}
	
	return aMasterCache;

}

#pragma mark - Add/Remove Cache Silos

- (void)addCacheSilo:(SnSCacheSilo*)iCacheSilo predicateString:(NSString *)iStrPredicate
{
	[_caches setObject:iCacheSilo forKey:iStrPredicate];
	
	// Saves master cache into disk each time a new silo is added
	[self performSelectorInBackgroundWithAutoreleasePool:@selector(archive)];
}

- (void)removeCacheSilo:(SnSCacheSilo*)iCacheSilo
{
	for (NSString* aKey in [_caches allKeys])
	{
		SnSCacheSilo* aSilo = [_caches objectForKey:aKey];
		if (aSilo == iCacheSilo)
		{
			[aSilo removeCacheFolder];
			[_caches removeObjectForKey:aKey];
			
			// Saves master cache into disk each time a silo is removed
			[self performSelectorInBackgroundWithAutoreleasePool:@selector(archive)];

		}
	}
}

- (void)removeAllCaches
{
	@synchronized(self)
	{
		// Start by removing all caches silo one by one
		for (NSString* aKey in [_caches allKeys])
		{
			SnSCacheSilo* aSilo = [_caches objectForKey:aKey];
			
			[aSilo removeCacheFolder];
			[_caches removeObjectForKey:aKey];
		}
		
		// and remove the cache index
		NSString* aMasterFilePath = [SnSMasterCache masterCachePath];
		NSError* aError = nil;
		[[NSFileManager defaultManager] removeItemAtPath:aMasterFilePath error:&aError];
	}
}
 
- (void)reloadAllCaches
{
	NSString* aCachePath = [SnSMasterCache cachesPath];
	NSFileManager* aFileManager = [NSFileManager defaultManager];
	
	NSError* aError = nil;
	NSArray* aCaches = [aFileManager contentsOfDirectoryAtPath:aCachePath error:&aError];
	
	if (aError != nil)
	{
		SnSCacheError* aCacheError = [SnSCacheError errorWithCode:SnSCacheErrorUnarchiveFailed
											 localizedDescription:[aError localizedDescription]];
		
		[[SnSCacheException exceptionWithError:aCacheError] raise];
	}
	
	for (NSString* aFolder in aCaches)
	{
		//NSString* aSiloPath = [aFolder stringByAppendingPathComponent:@"%@/%@.plist", aFolder, kSnSCacheName];
		
	}
}

#pragma mark - Add/Remove Items from Cache

- (void)storeCacheItem:(SnSCacheItem*)iItem forQuery:(id)iQuery
{
	SnSCacheSilo* aCacheSilo = [self cacheSiloForQuery:iQuery];
	[aCacheSilo storeCacheItem:iItem forKey:iQuery];
}

#pragma mark - Retreive Items from Cache

- (SnSCacheSilo*)cacheSiloForQuery:(id)iQuery
{
	SnSCacheSilo* aCacheSilo = nil;
	
	// If there is only one cache use it
	if ([_caches count] == 1)	
		aCacheSilo = [_caches objectForKey:[[_caches allKeys] objectAtIndex:0]];
	
	// Otherwise we need to find which cache might contain the query
	else	
	{
		// First retreive which cache might contain the query
		for (NSString* aPredicateFormat in [_caches allKeys])
		{
			NSPredicate* aPredicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"self like '%@'", aPredicateFormat]];
			if ([aPredicate evaluateWithObject:iQuery])
			{
				// If we've already found a matched silo for the specified query
				if (aCacheSilo != nil)
				{
					SnSCacheError* aError = [SnSCacheError errorWithCode:SnSCacheErrorTooManySilosFound
																userInfo:[NSDictionary dictionaryWithObjectsAndKeys:NSLocalizedDescriptionKey,
																		  [NSString stringWithFormat:@"At least two caches matching query: %@ where found", iQuery], nil]];
					
					[[SnSCacheException exceptionWithError:aError] raise];
				}
				else
					// Found the cache holding the query
					aCacheSilo = [_caches objectForKey:aPredicateFormat];
			}
		}
	}
	
	// No silo found ? no cache can find that query
	if (!aCacheSilo)
	{
		SnSCacheError* aError = [SnSCacheError errorWithCode:SnSCacheErrorCacheNotFound
													userInfo:[NSDictionary dictionaryWithObjectsAndKeys:NSLocalizedDescriptionKey,
															  [NSString stringWithFormat:@"No cache initiliazed to match key: %@", iQuery], nil]];
		
		[[SnSCacheException exceptionWithError:aError] raise];
		
	}
	
	return aCacheSilo;
}

- (SnSCacheItem*)cachedItemForQuery:(id)iQuery
{
	SnSCacheItem* aCachedItem = nil;
	SnSCacheSilo* aCacheSilo = [self cacheSiloForQuery:iQuery];
	
	// Retreive item from cache
	aCachedItem = [aCacheSilo cachedItemForKey:iQuery];
	
	return aCachedItem;
}

#pragma mark - Utils Methods

+ (NSString*)cachesPath
{
	return [NSString stringWithFormat:@"%@/Caches", [SnSUtils applicationCachesPath]];
}

+ (NSString*)masterCachePath
{
	return  [[SnSMasterCache cachesPath] stringByAppendingFormat:@"/%@.plist", self.class];

}

@end
