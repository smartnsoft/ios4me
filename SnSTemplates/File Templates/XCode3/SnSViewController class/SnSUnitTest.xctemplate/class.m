// GHUnit is a test framework for Objective-C (Mac OS X 10.5 and above and iPhone 3.x and above). 
// It can be used with SenTestingKit, GTM or all by itself.
// 
// For example, your test cases will be run if they subclass any of the following:
// 
// GHTestCase
// SenTestCase
// GTMTestCase
// Source: http://github.com/gabriel/gh-unit
// 
// View docs online: http://gabriel.github.com/gh-unit/

//
//  ___FILENAME___
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright ___YEAR___ ___ORGANIZATIONNAME___. All rights reserved.
//

#import "___FILEBASENAME___.h"


@implementation ___FILEBASENAMEASIDENTIFIER___


// By default NO, but if you have a UI test or test dependent on running on the main thread return YES.
// Also an async test that calls back on the main thread, you'll probably want to return YES.
- (BOOL)shouldRunOnMainThread
{
    return NO;
}

// Run at start of all tests in the class
- (void)setUpClass 
{
}

// Run at end of all tests in the class
- (void)tearDownClass
{
	
}

// Run before each test method
- (void)setUp 
{
	
}

// Run after each test method
- (void)tearDown
{
}  


@end
