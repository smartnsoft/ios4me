// For iOS
#import <GHUnitIOS/GHUnit.h> 
// For Mac OS X
//#import <GHUnit/GHUnit.h>

#import <ios4me/SnSFramework.h>

static NSInteger kTestCacheHighCapacity = 1024;
static NSInteger kTestCacheLowCapacity	= 128;
static NSInteger kTestCacheMaxHits		= 64;

#pragma mark - GHTestCase

@interface TestCache : GHAsyncTestCase <SnSCacheDelegate> 
{
	SEL currentTest_;
	
	SnSAbstractCache* cache_;
	NSDictionary* actions_;  // Nb of bytes -> nb of times it will be hit
}

- (NSDictionary*)createTestActions:(NSInteger)iNbObjects;

- (void)checkTestAddData;
@end

@implementation TestCache

- (BOOL)shouldRunOnMainThread {
    // By default NO, but if you have a UI test or test dependent on running on the main thread return YES.
    // Also an async test that calls back on the main thread, you'll probably want to return YES.
    return NO;
}

- (void)setUpClass
{	
	cache_		= [[SnSMemoryCache alloc] initWithMaxCapacity:kTestCacheHighCapacity minCapacity:kTestCacheLowCapacity];
	actions_	= [[self createTestActions:8] retain];
	
	[[SnSCacheChecker instance] setDelegate:self];
	[[SnSCacheChecker instance] setFrequency:1];
}

- (void)tearDownClass 
{
	[cache_ release];
	[actions_ release];
	
	[[SnSCacheChecker instance] reset];
}

- (void)setUp {
    // Run before each test method
}

- (void)tearDown {
    // Run after each test method
}  

#pragma mark - Tests

- (void)test01_AbstractCache
{
	[self prepare];
	
	currentTest_ = _cmd;
	
	GHAssertNotNil(cache_, @"Main memory cache could not be created");

	[self waitForStatus:kGHUnitWaitStatusSuccess timeout:3.0];	
}

- (void)test02_AddData
{
	[self prepare];
	
	currentTest_ = _cmd;
	
	for (NSString* aKey in [actions_ allKeys])
	{
		NSInteger aNbBytes = [[aKey stringByStrippingNonNumbers] integerValue];
		
		unsigned char* someBytes = (unsigned char*)malloc(aNbBytes);
		NSData* aData = [NSData dataWithBytes:someBytes length:aNbBytes];
		free(someBytes);
		
		
		[cache_ storeData:aData forKey:[NSURL URLWithString:aKey]];
	}	
		
	[self waitForStatus:kGHUnitWaitStatusSuccess timeout:3.0];	
}

- (void)test03_Hits
{
	[self prepare];
	
	currentTest_ = _cmd;
	
	for (NSString* aKey in [actions_ allKeys])
	{
		NSURL* aURL = [NSURL URLWithString:aKey];
		NSUInteger aNbHit = [[actions_ objectForKey:aKey] integerValue];
		
		// This should increment the number of hits on each cached object
		for (NSInteger i = 0; i < aNbHit; ++i)
			[cache_  cachedDataForKey:aURL];	
		
		// Check for the number of hits
		SnSCacheItem* aItem = [cache_ cachedItemForKey:aURL];
		
		GHAssertEquals(aItem.hits, aNbHit, @"Hits Received: %d / Hits Expected: %d", aItem.hits, aNbHit);
		
	}	
	
}

#pragma mark - Checks


- (void)checkTestAddData
{
	SnSLogD(@"Cache Size, %d", cache_.cacheSize);
	
	NSInteger aTotalBytes = 0;
	for (NSString* aKey in [actions_ allKeys])
		aTotalBytes += [[aKey stringByStrippingNonNumbers] integerValue];
	
	SnSLogD(@"aTotalBytes Size, %d", aTotalBytes);
	
	GHAssertEquals(aTotalBytes, 
				   cache_.cacheSize, 
				   @"The total cache size [%d] is not of excpeted size [%d]", 
				   cache_.cacheSize,
				   aTotalBytes);

	[self notify:kGHUnitWaitStatusSuccess forSelector:currentTest_];

}

						   
#pragma mark - SnSCacheDelegate

- (void)didProcessChecksOnCache:(SnSAbstractCache*)iCache
{
	SnSLogD(@"");
	
	if ([NSStringFromSelector(currentTest_) isEqualToString:@"test01_AbstractCache"])
		[self notify:kGHUnitWaitStatusSuccess forSelector:currentTest_];
	else if ([NSStringFromSelector(currentTest_) isEqualToString:@"test02_AddData"])
		[self checkTestAddData];
		
}

#pragma mark - Useful

- (NSDictionary*)createTestActions:(NSInteger)iNbObjects
{
	NSMutableDictionary* aDic = [NSMutableDictionary dictionaryWithCapacity:iNbObjects];
	
	NSInteger aRatio = kTestCacheHighCapacity/iNbObjects;
	
	for (NSInteger i = 0; i < iNbObjects; ++i)
	{
		NSInteger aRandomValue = arc4random()%(aRatio);
		NSInteger aRandomHits  = arc4random()%(kTestCacheMaxHits);
		[aDic setValue:[NSString stringWithFormat:@"%d", aRandomHits]
				forKey:[NSString stringWithFormat:@"bytes://%d", aRandomValue]];
	}
	
	return [NSDictionary dictionaryWithDictionary:aDic];
}


@end