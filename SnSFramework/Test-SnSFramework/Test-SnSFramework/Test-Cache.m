// For iOS
#import <GHUnitIOS/GHUnit.h> 
// For Mac OS X
//#import <GHUnit/GHUnit.h>

#import <ios4me/SnSFramework.h>


#pragma mark - GHTestCase

@interface TestCache : GHAsyncTestCase <SnSCacheDelegate> 
{
	SEL currentTest_;
	
	SnSAbstractCache* cache_;
}

@end

@implementation TestCache

- (BOOL)shouldRunOnMainThread {
    // By default NO, but if you have a UI test or test dependent on running on the main thread return YES.
    // Also an async test that calls back on the main thread, you'll probably want to return YES.
    return NO;
}

- (void)setUpClass
{	
	cache_ = [[SnSMemoryCache alloc] initWithMaxCapacity:1024 minCapacity:16];
	
	[[SnSCacheChecker instance] setDelegate:self];
	[[SnSCacheChecker instance] setFrequency:5];
}

- (void)tearDownClass 
{
	[cache_ release];
	
	[[SnSCacheChecker instance] reset];
}

- (void)setUp {
    // Run before each test method
}

- (void)tearDown {
    // Run after each test method
}  

#pragma mark - Abstract Cache

- (void)test01_AbstractCache
{
	[self prepare];
	
	currentTest_ = _cmd;
	
	GHAssertNotNil(cache_, @"Main memory cache could not be created");

	[self waitForStatus:kGHUnitWaitStatusSuccess timeout:20.0];	
}

						   
#pragma mark - SnSCacheDelegate

- (void)didProcessChecksOnCache:(SnSAbstractCache*)iCache
{
	if ([NSStringFromSelector(currentTest_) isEqualToString:@"test01_AbstractCache"])
		[self notify:kGHUnitWaitStatusSuccess forSelector:@selector(test01_AbstractCache)];
		
}

@end