// For iOS
#import <GHUnitIOS/GHUnit.h> 
// For Mac OS X
//#import <GHUnit/GHUnit.h>

#import <Smart&Soft/SnSFramework.h>


#pragma mark - GHTestCase

@interface TestCache : GHTestCase { }

@end

@implementation TestCache

- (BOOL)shouldRunOnMainThread {
    // By default NO, but if you have a UI test or test dependent on running on the main thread return YES.
    // Also an async test that calls back on the main thread, you'll probably want to return YES.
    return NO;
}

- (void)setUpClass {
    // Run at start of all tests in the class
}

- (void)tearDownClass {
    // Run at end of all tests in the class
}

- (void)setUp {
    // Run before each test method
}

- (void)tearDown {
    // Run after each test method
}  

#pragma mark - Cache Silo


- (void)testCacheDiskPath 
{
    // Another test
    SnSCacheSilo* aSilo1 = [[SnSCacheSilo alloc] initWithMemoryCapacity:1024 diskCapacity:1024];
    SnSCacheSilo* aSilo2 = [[SnSCacheSilo alloc] initWithMemoryCapacity:1024 diskCapacity:1024];
	
    GHTestLog(@"Silo Path: %@: ", [aSilo1 diskPath]);
	GHTestLog(@"Silo Path: %@: ", [aSilo2 diskPath]);
	
	
	// The two paths must be different
	GHAssertNotEqualStrings([aSilo1 diskPath], [aSilo2 diskPath], @"Silo1 and Silo2 have same disk path %@", [aSilo1 diskPath]);
	
	NSString* aApplicationPath = [SnSUtils applicationCachesPath];
	NSRange aRange1 = [[aSilo1 diskPath] rangeOfString:aApplicationPath];
	NSRange aRange2 = [[aSilo2 diskPath] rangeOfString:aApplicationPath];
	
	// Must contain the application path
	GHAssertTrue(aRange1.length > 0, @"Application Path: %@ was not in the silo path %@", aApplicationPath, [aSilo1 diskPath]);
	GHAssertTrue(aRange2.length > 0, @"Application Path: %@ was not in the silo path %@", aApplicationPath, [aSilo2 diskPath]);
	
	// Release objects
	[aSilo1 removeCacheFolder];
	[aSilo2 removeCacheFolder];
	[aSilo1 release];
	[aSilo2 release];
}

- (void)testCacheRemoveFolder
{
	SnSCacheSilo* aSilo1 = [[SnSCacheSilo alloc] initWithMemoryCapacity:1024 diskCapacity:1024];
	
	
	NSString* aCachePath	= [[SnSUtils applicationCachesPath] stringByAppendingFormat:@"/%@",SnSConstantCacheFolderName];
	NSFileManager* aManager = [NSFileManager defaultManager];
	
	GHTestLog(@"Cache Path: %@: ", aCachePath);
	
	// Prior to remove the cache folders there should be at least more that one (given previous tests were succesful)
	GHAssertTrue([aManager fileExistsAtPath:[aSilo1 diskPath]], @"No cache present at %@", [aSilo1 diskPath]);
	
	[aSilo1 removeCacheFolder];
	
	// The cache should have been deleted
	GHAssertFalse([aManager fileExistsAtPath:[aSilo1 diskPath]], @"Cache should be removed at %@", [aSilo1 diskPath]);


}





- (void)testCacheArchive
{
	SnSCacheSilo* aCacheArchive		= [[SnSCacheSilo alloc] initWithMemoryCapacity:128 diskCapacity:1024];
	
	NSInteger aDataLength = 128;
	NSString* aKey1 = @"testCacheArchive";
	
	// Construct data object
	unsigned char* someBytes = (unsigned char*)malloc(aDataLength);
	NSData* aData = [NSData dataWithBytes:someBytes length:aDataLength];
	free(someBytes);
	
	@try
	{ 
	
		SnSCacheItem* aCacheItem = [[SnSCacheItem alloc] initWithKey:aKey1
																date:[NSDate date] 
																data:aData];
		
		[aCacheArchive storeCacheItem:aCacheItem forKey:aCacheItem.key];
		
		// Archive Cache
		[aCacheArchive archive];
		
		// Reload new cache from saved one
		NSString* aPath = [aCacheArchive.diskPath stringByAppendingFormat:@"/%@.plist", kSnSCacheName];
		SnSCacheSilo* aCacheUnarchive  = [SnSCacheSilo cacheUnarchivedFromPath:aPath];
		GHAssertNotNil(aCacheUnarchive, @"Failed to retreive cache from path: %@: ", aPath);
		
		
		// Retreive Item
		SnSCacheItem* aUnarchivedItem = [aCacheUnarchive cachedItemForKey:aKey1];
		GHAssertNotNil(aUnarchivedItem, @"Failed to retreive item for key: %@: ", aKey1);
		
		// Check item are equal
		GHAssertTrue([aUnarchivedItem isEqualToCacheItem:aCacheItem], @"Unarchived item %@ and %@ should be equal", aUnarchivedItem, aCacheItem);
		
	}
	@catch (NSException *exception) 
	{
		SnSLogE(@"%@",exception);
		GHAssertTrue(0, @"%@", exception);
	}
	@finally 
	{
		//Release
		[aCacheArchive removeCacheFolder];
		[aCacheArchive release];
	}
	
	

}

#pragma mark - Master Cache

- (void)testMasterCacheAdd
{
	SnSURLCacheSilo* aURLCache		= [[SnSURLCacheSilo alloc] initWithMemoryCapacity:128 diskCapacity:1024];
	SnSMasterCache* aMasterCache	= [SnSMasterCache instance];
	
	GHAssertNotNil(aMasterCache.caches, @"");
	GHAssertTrue([aMasterCache.caches count] == 0, @"");
	
	[aMasterCache addCacheSilo:aURLCache predicateString:@"testMasterCacheAdd*"];
	
	GHAssertTrue([aMasterCache.caches count] == 1, @"");
	
	// Release
	[aURLCache release];
}


- (void)testMasterCacheStore
{
	SnSCacheSilo* aURLCache		 = [[SnSCacheSilo alloc] initWithMemoryCapacity:128 diskCapacity:1024];
	SnSMasterCache* aMasterCache = [SnSMasterCache instance];
	
	[aMasterCache addCacheSilo:aURLCache predicateString:@"store*"];
	
	NSArray* aArrayDataLength = [NSArray arrayWithObjects:[NSNumber numberWithInt:32], [NSNumber numberWithInt:512], [NSNumber numberWithInt:150], nil];
	NSMutableArray* aArrayCachedItems = [[NSMutableArray alloc] initWithCapacity:[aArrayDataLength count]];
	
	// Build Cache Items
	for (int i = 0; i < [aArrayDataLength count]; i++)
	{
		NSInteger aDataLength = [[aArrayDataLength objectAtIndex:i] integerValue];
		NSString* aKey = [NSString stringWithFormat:@"store%d", i];

		// Construct data object
		unsigned char* someBytes = (unsigned char*)malloc(aDataLength);
		NSData* aData = [NSData dataWithBytes:someBytes length:aDataLength];
		free(someBytes);
		
		
		SnSCacheItem* aCacheItem = [[SnSCacheItem alloc] initWithKey:aKey
																date:[NSDate date] 
																data:aData];
		@try
			{ [aMasterCache storeCacheItem:aCacheItem forQuery:aKey]; }
		@catch (NSException *exception) 
		{
			SnSLogE(@"%@",exception);
			GHAssertTrue(0, @"%@", exception);
		}
		@finally {}
		[aArrayCachedItems addObject:aCacheItem];
		
		[aCacheItem release];
	}
	
	// Test Items
	for (int i = 0; i < [aArrayDataLength count]; i++)
	{
		NSInteger aDataLength = [[aArrayDataLength objectAtIndex:i] integerValue];
		NSString* aKey = [NSString stringWithFormat:@"store%d", i];
		SnSCacheItem* aSavedItem	= [aArrayCachedItems objectAtIndex:i];
		SnSCacheItem* aCachedItem	= [aMasterCache cachedItemForQuery:aKey];
		
		GHAssertNotNil(aCachedItem, @"[aMasterCache cachedItemForQuery:@\"Key1\"] should not be nil");
		GHAssertTrue([aCachedItem isEqualToCacheItem:aSavedItem], @"The retreived Item %@ should be exactly the same as the created one %@", aCachedItem, aSavedItem);
		GHAssertTrue([aCachedItem.data length] == aDataLength, @"The retreived Item data %d should be of size %d", [aCachedItem.data length], aDataLength);

	}

	// Release
	[aURLCache release];
	[aArrayCachedItems release];
	
}

/**
 *	Checks that the master cache is correctly archived (written to disk) and then
 *	successfully unarchived from a different instance
 */
- (void)testMasterCacheArchive
{
	SnSCacheSilo* aCache1		 = [[SnSCacheSilo alloc] initWithMemoryCapacity:128 diskCapacity:1024];
	SnSCacheSilo* aCache2		 = [[SnSCacheSilo alloc] initWithMemoryCapacity:128 diskCapacity:1024];
	SnSMasterCache* aMasterCache = [SnSMasterCache instance];
	
	NSInteger aDataLength1 = 50;
	NSInteger aDataLength2 = 150;
	
	// Construct data object
	unsigned char* someBytes1 = (unsigned char*)malloc(aDataLength1);
	unsigned char* someBytes2 = (unsigned char*)malloc(aDataLength2);

	NSData* aData1	= [NSData dataWithBytes:someBytes1 length:aDataLength1];	
	NSData* aData2	= [NSData dataWithBytes:someBytes2 length:aDataLength2];
	
	free(someBytes1);
	free(someBytes2);

	
	[aMasterCache addCacheSilo:aCache1 predicateString:@"testMasterCacheArchive_Cache1*"];
	[aMasterCache addCacheSilo:aCache2 predicateString:@"testMasterCacheArchive_Cache2*"];
	
	SnSCacheItem* aCacheItem1 = [[SnSCacheItem alloc] initWithKey:@"testMasterCacheArchive_Cache1_1"
															date:[NSDate date] 
															data:aData1];
	
	SnSCacheItem* aCacheItem2 = [[SnSCacheItem alloc] initWithKey:@"testMasterCacheArchive_Cache2_1"
															date:[NSDate date] 
															data:aData2];
	
	// Store Items
	[aMasterCache storeCacheItem:aCacheItem1 forQuery:aCacheItem1.key];
	[aMasterCache storeCacheItem:aCacheItem2 forQuery:aCacheItem2.key];
	
	NSInteger aCacheCount = [aMasterCache.caches count];
	
	[aMasterCache archive];
	
	NSString* aMasterCachePath = [SnSMasterCache masterCachePath];
	
	GHAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:aMasterCachePath], @"Master Cache was not archived at path %@", aMasterCachePath);
	
	[aMasterCache reset];
	
	aMasterCache = [SnSMasterCache instance];
	
	
	// Checks boths silos have been archived
	
	NSString* aPathSilo1 = [aCache1.diskPath stringByAppendingFormat:@"/%@.plist", kSnSCacheName];
	NSString* aPathSilo2 = [aCache2.diskPath stringByAppendingFormat:@"/%@.plist", kSnSCacheName];

	GHAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:aPathSilo1], @"No cache present at %@", aPathSilo1);
	GHAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:aPathSilo2], @"No cache present at %@", aPathSilo2);

	
	GHAssertTrue([aMasterCache.caches count] == aCacheCount, @"The master cache was not restored properly. It should have %d silos in it", aCacheCount);
	
	SnSCacheItem* aRetreivedItem1 = [aMasterCache cachedItemForQuery:@"testMasterCacheArchive_Cache1_1"];
	SnSCacheItem* aRetreivedItem2 = [aMasterCache cachedItemForQuery:@"testMasterCacheArchive_Cache2_1"];
	
	
	GHAssertTrue([aRetreivedItem1 isEqualToCacheItem:aCacheItem1], @"Retreived Cached Item [%@] should be equalt to [%@]", aRetreivedItem1, aCacheItem1);
	GHAssertTrue([aRetreivedItem2 isEqualToCacheItem:aCacheItem2], @"Retreived Cached Item [%@] should be equalt to [%@]", aRetreivedItem2, aCacheItem2);
	
	[aCache1 release];
	[aCache2 release];





}

/**	Checks the behaviour of te removeAllCaches 
 *	It must be run at the end hence the ZZ prefix (GHUnitTest runs the test alphetical order)
 */
- (void)testZZMasterCacheRemoveAll
{
	
	NSString* aCachePath	= [[SnSUtils applicationCachesPath] stringByAppendingFormat:@"/%@",SnSConstantCacheFolderName];
	NSFileManager* aManager = [NSFileManager defaultManager];
	
	NSArray* aFiles	= nil;
	NSError* aError = nil;
	
	aFiles = [aManager contentsOfDirectoryAtPath:aCachePath error:&aError];

	
	// Prior to remove the cache folders there should be at least more that one (given previous tests were succesful)
	GHAssertTrue([aFiles count] > 0, @"The caches folder %@ not be empty be empty", aCachePath);

	[[SnSMasterCache instance] removeAllCaches];
	
	aCachePath = [[SnSUtils applicationCachesPath] stringByAppendingFormat:@"/%@",SnSConstantCacheFolderName];
	aFiles = [aManager contentsOfDirectoryAtPath:aCachePath error:&aError];
	
	if (aError)
		[[NSException exceptionWithName:@"GHUnitTestException" reason:[aError localizedDescription] userInfo:nil] raise];
	
	GHAssertTrue([aFiles count] == 0, @"The caches folder %@ should be empty but %d items remain", aCachePath, [aFiles count]);
	
	
}
						   
#pragma mark - Useful Methods
						   

@end