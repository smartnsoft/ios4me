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

// Controllers
#import "ImageRetrievalViewController.h"

#define VIEW_X(v)			((v).frame.origin.x)
#define VIEW_Y(v)			((v).frame.origin.y)
#define VIEW_WIDTH(v)		((v).frame.size.width)
#define VIEW_HEIGHT(v)		((v).frame.size.height)

@implementation AutomationViewController

#pragma mark -
#pragma mark AutomationViewController
#pragma mark -

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

- (void)pushControllerNamed:(NSString *)iName
{
	// Create Controller from name
	SnSViewController* aController = [[NSClassFromString(iName) alloc] initWithNibName:nil bundle:nil];
	
	// Push Controller
	[[self navigationController] pushViewController:aController animated:YES];
	
	// Release
	[aController release];
}
#pragma mark -
#pragma mark SnSViewControllerLifeCycle
#pragma mark -

- (id) retrieveBusinessObjects
{
	SnSLogD(@"Retrieving Business Objects");
	
	NSMutableArray* aControllers = [NSMutableArray array];
		
	// Here, add all the controller you want to test
	[aControllers addObject:NSStringFromClass([ImageRetrievalViewController class])];
		
    return aControllers;
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
	
	// Init Memory Cache
	[[SnSMemoryCache instance] setHighCapacity:1024*1024*1];
	[[SnSMemoryCache instance] setLowCapacity:1024*400];
	[[SnSCacheChecker instance] setFrequency:30];
	
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
#pragma mark UITableViewDataSource
#pragma mark -

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell* aCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
	
	if (aCell == nil)
		aCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
									   reuseIdentifier:NSStringFromClass([self class])] autorelease];
		
	NSString* aControllerStr = [businessObjects objectAtIndex:indexPath.row];

	aCell.textLabel.text = aControllerStr;
	
	return aCell;
		
}

#pragma mark -
#pragma mark UITableViewDelegate
#pragma mark -

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString* aControllerStr = [businessObjects objectAtIndex:indexPath.row];
	
	[self pushControllerNamed:aControllerStr];
	
}



#pragma mark -
#pragma mark UIViewController
#pragma mark -

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
