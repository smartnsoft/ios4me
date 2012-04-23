//
//  «FILENAME»
//  «PROJECTNAME»
//
//  Created by «FULLUSERNAME» on «DATE».
//  Copyright «YEAR» «ORGANIZATIONNAME». All rights reserved.
//

«OPTIONALHEADERIMPORTLINE»

#define VIEW_X(v)			((v).frame.origin.x)
#define VIEW_Y(v)			((v).frame.origin.y)
#define VIEW_WIDTH(v)		((v).frame.size.width)
#define VIEW_HEIGHT(v)		((v).frame.size.height)

@implementation «FILEBASENAMEASIDENTIFIER»

#pragma mark -
#pragma mark «FILEBASENAMEASIDENTIFIER»
#pragma mark -

- (void)updateDisplay
{
	
}

#pragma mark -
#pragma mark SnSViewControllerLifeCycle
#pragma mark -

/**
 * Called after the loadView call
 */
- (void)onRetrieveDisplayObjects:(UIView *)view
{
	[super onRetrieveDisplayObjects:view];
	
}

/**
 * Called after the viewDidLoad call
 */
- (void)onRetrieveBusinessObjects
{	
	[super onRetrieveBusinessObjects];
	
}

/**
 * Called after the viewWillAppear call
 */
- (void)onFulfillDisplayObjects
{
	[super onFulfillDisplayObjects];
	
}

/**
 * Called after the viewDidAppear call
 */
- (void)onSynchronizeDisplayObjects
{
	[super onSynchronizeDisplayObjects];
	
}

/**
 * Called after the viewDidUnload call
 */
- (void)onDiscarded
{
	[super onDiscarded];
}

#pragma mark -
#pragma mark SnSViewControllerExceptionHandler
#pragma mark -

/*
 
 - (BOOL) onBusinessObjectException:(id<SnSViewControllerLifeCycle>)aggregate exception:(SnSBusinessObjectException *)exception resume:(BOOL *)resume;
 - (BOOL) onLifeCycleException:(id<SnSViewControllerLifeCycle>)aggregate exception:(SnSLifeCycleException *)exception resume:(BOOL *)resume;
 - (BOOL) onOtherException:(id<SnSViewControllerLifeCycle>)aggregate exception:(NSException *)exception resume:(BOOL *)resume;
 
 */


#pragma mark -
#pragma mark UIViewController
#pragma mark -

#pragma mark Basics

- (void)dealloc
{
	[super dealloc];
}

- (void)didReceiveMemoryWarning
{
	SnSLogW(@"");
	
	[super didReceiveMemoryWarning];
	
}

#pragma mark Rotation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
	return DeviceOrientationSupported(interfaceOrientation);
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	SnSLogD(@"");
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	SnSLogD(@"");
}




@end
