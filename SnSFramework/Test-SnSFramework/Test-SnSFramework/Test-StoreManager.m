//
//  Test-StoreManager.m
//  Test-SnSFramework
//
//  Created by Johan Attali on 8/10/11.
//  Copyright 2011 Smart&Soft. All rights reserved.
//

// Only run this test on the device
#if !TARGET_IPHONE_SIMULATOR

// For iOS
#import <GHUnitIOS/GHUnit.h> 
// For Mac OS X
//#import <GHUnit/GHUnit.h>

#import <StoreKit/StoreKit.h>

@interface TestStoreManager : GHAsyncTestCase <SnSStoreManagerDelegate>
{
	SnSStoreManager* _storeManager;
}
@end

@implementation TestStoreManager

- (BOOL)shouldRunOnMainThread {
    // By default NO, but if you have a UI test or test dependent on running on the main thread return YES.
    // Also an async test that calls back on the main thread, you'll probably want to return YES.
    return NO;
}

- (void)setUpClass {
    // Run at start of all tests in the class
	_storeManager = [SnSStoreManager instance];
}

- (void)tearDownClass {
    // Run at end of all tests in the class
}

- (void)setUp {
    // Run before each test method
}

- (void)tearDown {
    // Run after each test method
	[[SnSStoreManager instance] reset];
}  

- (void)testFailBuy
{	
	[self prepare];
	
	[_storeManager buyProductIdentifier:@"testerror"];

	//[self performSelector:@selector(_testFailBuyNotify) withObject:nil afterDelay:0.0];
	[self waitForStatus:kGHUnitWaitStatusSuccess timeout:20.0];
	
	
}
	 
- (void)_testFailBuyNotify 
{
	[self notify:kGHUnitWaitStatusSuccess forSelector:@selector(testFailBuy)];
}

#pragma mark SnSStoreManagerDelegate

- (void)storeManager:(SnSStoreManager *)storeManager didFailedTransaction:(SKPaymentTransaction *)transaction
{
	SnSLogI(@"error: %@", transaction.error);
}


@end

#endif // #if !TARGET_IPHONE_SIMULATOR
