// For iOS
#import <GHUnitIOS/GHUnit.h> 
// For Mac OS X
//#import <GHUnit/GHUnit.h>

#import <ios4me/SnSFramework.h>


#pragma mark - GHTestCase

@interface TestCache : GHAsyncTestCase <SnSCacheDelegate> { }

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

#pragma mark - Abstract Cache

- (void)test01_AbstractCache
{
	[self prepare];
	
	SnSAbstractCache* aCache = [[SnSMemoryCache alloc] initWithMaxCapacity:1024 minCapacity:16];
	
	[[SnSCacheChecker instance] setDelegate:self];
	[[SnSCacheChecker instance] setFrequency:5];
	
	[self waitForStatus:kGHUnitWaitStatusSuccess timeout:20.0];
	
	
}

						   
#pragma mark - SnSCacheDelegate

- (void)didProcessChecksOnCache:(SnSAbstractCache*)iCache
{
	SnSLogD(@"");
	
}

@end