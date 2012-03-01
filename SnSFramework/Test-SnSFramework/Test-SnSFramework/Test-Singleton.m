// For iOS
#import <GHUnitIOS/GHUnit.h> 
// For Mac OS X
//#import <GHUnit/GHUnit.h>

#pragma mark - Test Classes

@interface ChildSingleton : SnSSingleton
{
}
@end

@implementation ChildSingleton

@end

@interface OtherChildSingleton : SnSSingleton
{
}
@end

@implementation OtherChildSingleton

@end

#pragma mark - GHTestCase

@interface TestSingleton : GHTestCase 
{
	NSString* _singleton1;
	NSString* _singleton2;
}
	
@end

@implementation TestSingleton

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
	[_singleton1 release];
	[_singleton2 release];
}

- (void)setUp {
    // Run before each test method
}

- (void)tearDown {
    // Run after each test method
	[[ChildSingleton instance] reset];
}  

- (void)testInstance
{	
	GHAssertEquals([ChildSingleton instance], [ChildSingleton instance], @"Singleton instances should be the same");

	_singleton1 = [[NSString stringWithFormat:@"%p", [ChildSingleton instance]] retain];
}

- (void)testTwoSingletons
{
	ChildSingleton* aSingleton = [ChildSingleton instance];
	OtherChildSingleton* aOtherSingleton = [OtherChildSingleton instance];
	
	GHAssertFalse([aOtherSingleton isEqual:aSingleton], @"Singletons: %@ and %@ have same address", [aSingleton class], [aOtherSingleton class]);
}

- (void)testReset
{	
	_singleton2 = [[NSString stringWithFormat:@"%p", [ChildSingleton instance]] retain];
	
	GHAssertNotEqualStrings(_singleton1, _singleton2, @"Reset method of the singleton might have failed or not executed");
}



@end