/* 
 * Copyright (C) 2009-2010 Smart&Soft.
 * All rights reserved.
 *
 * The code hereby is the full property of Smart&Soft, SIREN 517 961 744.
 * http://www.smartnsoft.com - contact@smartnsoft.com
 * 
 * You are not allowed to use the source code or the resulting binary code, nor to modify the source code, without prior permission of the owner.
 */

//
//  AutomationViewController.h
//  Automation
//
//  Created by «FULLUSERNAME» on «DATE».
//  Copyright «YEAR» «ORGANIZATIONNAME». All rights reserved.
//  Created by ApplicationAuthor on ApplicationCreationDate.
//

#import "AutomationViewController.h"
#import "AboutViewController.h"

#define kControllerViewWidth self.view.frame.size.width
#define kControllerViewHeight self.view.frame.size.height

#pragma mark -
#pragma mark AutomationViewController

@implementation AutomationViewController

#pragma mark -
#pragma mark AutomationViewController

- (void) onAbout:(id)sender
{
	// Comment/Uncomment next line to simulate the loading view
	//[SnSAppDelegate startLoading:self.responderRedirector withMessage:nil];
	
	// -----------------------------
	// Create the diplay controller
	// -----------------------------
	SnSViewController * displayController = [[AboutViewController alloc] init];
	UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController:displayController];
	navController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	navController.navigationBar.barStyle = UIBarStyleBlack;
	navController.navigationBar.tintColor = NavigationBarTintColor;
	
	// -----------------------------
	// Present controllers
	// -----------------------------
	[self presentModalViewController:navController animated:YES];
	
	// -----------------------------
	// Release objects
	// -----------------------------
	[displayController release];

	// Comment/Uncomment next line to simulate the loading view
	//[SnSAppDelegate stopLoading:self.responderRedirector];
}

- (void) updateDisplay
{
	
}

#pragma mark -
#pragma mark SnSViewControllerLifeCycle

- (id) retrieveBusinessObjects
{
	SnSLogD(@"Retrieving Business Objects");

    // Uncomment to simulate the time to obtain business objects
    // sleep(3);
	
    return nil;
}

- (void) onRetrieveDisplayObjects:(UIView *)view
{
	[super onRetrieveDisplayObjects:view];
	
	// -----------------------------
	// Setup current view
	// -----------------------------
	self.view.backgroundColor = [UIColor whiteColor];
	
	// -----------------------------
	// Add About button
	// -----------------------------
	UIButton * aboutButton = [[UIButton buttonWithType:UIButtonTypeInfoDark] retain];
	aboutButton.frame = CGRectMake(screenWidth-(aboutButton.frame.size.width*2),							// X
								   screenHeight-navigationBarHeight-(aboutButton.frame.size.height*2),		// Y
								   aboutButton.frame.size.width*2,											// Width
								   aboutButton.frame.size.height*2);										// Height
	[aboutButton setContentMode:UIViewContentModeScaleAspectFit];
	[aboutButton addTarget:self.responderRedirector action:@selector(onAbout:) forControlEvents:UIControlEventTouchUpInside];
    
	// -----------------------------
	// Add Tabbar button
	// -----------------------------
    UIBarButtonItem * aboutBarButton = [[UIBarButtonItem alloc] initWithCustomView:aboutButton];
    self.navigationItem.rightBarButtonItem = aboutBarButton;
}

- (void) onRetrieveBusinessObjects
{
	[super onRetrieveBusinessObjects];
	
}

- (void) onFulfillDisplayObjects
{
	[super onFulfillDisplayObjects];
	
}

- (void) onSynchronizeDisplayObjects
{
	[super onSynchronizeDisplayObjects];
	
}

- (void) onDiscarded
{
	[super onDiscarded];
}

#pragma mark -
#pragma mark SnSViewControllerExceptionHandler

/*
 
 - (BOOL) onBusinessObjectException:(id<SnSViewControllerLifeCycle>)aggregate exception:(SnSBusinessObjectException *)exception resume:(BOOL *)resume;
 - (BOOL) onLifeCycleException:(id<SnSViewControllerLifeCycle>)aggregate exception:(SnSLifeCycleException *)exception resume:(BOOL *)resume;
 - (BOOL) onOtherException:(id<SnSViewControllerLifeCycle>)aggregate exception:(NSException *)exception resume:(BOOL *)resume;
 
 */


#pragma mark -
#pragma mark UIViewController

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
	return DeviceOrientationSupported(interfaceOrientation);
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	SnSLogI(@"");
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	SnSLogI(@"");
}

- (void)didReceiveMemoryWarning
{
	SnSLogW(@"");

	[super didReceiveMemoryWarning];
	
}

@end
