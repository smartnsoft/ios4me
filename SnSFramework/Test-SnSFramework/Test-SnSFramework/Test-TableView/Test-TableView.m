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
//  Test-TableView.m
//  Test-SnSFramework
//
//  Created by Johan Attali on 31/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Test-TableView.h"
#import "TouchSynthesis.h"

@implementation TestTableView


// By default NO, but if you have a UI test or test dependent on running on the main thread return YES.
// Also an async test that calls back on the main thread, you'll probably want to return YES.
- (BOOL)shouldRunOnMainThread
{
    return YES;
}

// Run at start of all tests in the class
- (void)setUpClass 
{
	_tableController = [[TableViewController alloc] init];
	[_tableController setDelegate:self];


}

// Run at end of all tests in the class
- (void)tearDownClass
{
	[_tableController release];
}

// Run before each test method
- (void)setUp 
{
	[_tableController viewDidLoad];
	[_tableController viewWillAppear:YES];
}

// Run after each test method
- (void)tearDown
{
}

- (void)testRetreiveBusinessObjects
{
	[self prepare]; 	
	NSIndexPath *aIndexPath = [NSIndexPath indexPathForRow:0 inSection:0]; 
    UITableViewCell *aCell = [_tableController tableView:[_tableController tableView] 
								   cellForRowAtIndexPath:aIndexPath]; 
	
	GHTestLog(@"aCell: %@", aCell);
	
	[_tableController viewDidLoad];
	
	[self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0]; 
}

- (void)testClickCell
{

	[self prepare]; 
	
//	UITableViewCell* aCell = [_tableController tableView:[_tableController tableView] 
//								   cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
	
	[self performTouchInView:[_tableController testButton]];
	[_tableController tableView:[_tableController tableView] didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
	
	[self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0]; 

}

#pragma mark - Useful

- (void)performTouchInView:(UIView *)view
{
	SnSLogI(@"%s",__FUNCTION__);

	UITouch *touch = [[UITouch alloc] initInView:view];
	UIEvent *event = [[UIEvent alloc] initWithTouch:touch];
	NSSet *touches = [[NSMutableSet alloc] initWithObjects:&touch count:1];
	
	[touch.view touchesBegan:touches withEvent:event];
	
	[touch setPhase:UITouchPhaseEnded];
	
	[touch.view touchesEnded:touches withEvent:event];
	
	[event release];
	[touches release];
	[touch release];
}


#pragma mark - TableViewDelegate



- (void)didCompleteRetreiveBusinessObjects
{
	id aBusinessObjects = [_tableController businessObjects];
	
	GHAssertNotNil(aBusinessObjects, @"aBusinessObjects should not be nil");
	
	[self notify:kGHUnitWaitStatusSuccess forSelector:@selector(testRetreiveBusinessObjects)];
}

- (void)didCompleteSelectRow
{
	[self notify:kGHUnitWaitStatusSuccess forSelector:@selector(testClickCell)];

}


@end
