//
//  «FILENAME»
//  «PROJECTNAME»
//
//  Created by «FULLUSERNAME» on «DATE».
//  Copyright «YEAR» «ORGANIZATIONNAME». All rights reserved.
//

«OPTIONALHEADERIMPORTLINE»

#define viewWidth self.view.frame.size.width
#define viewHeight self.view.frame.size.height

@implementation «FILEBASENAMEASIDENTIFIER»

#pragma mark -
#pragma mark «FILEBASENAMEASIDENTIFIER»

- (void) updateIpadDisplay
{
	
}

- (void) updateIphoneDisplay
{
  
}

- (void) updateDisplay
{
#ifdef __IPHONE_3_2
	if (IS_RUNNING_ON_IPAD)
	{
		[self updateIpadDisplay];
	}
	else
#endif
	{
		[self updateIphoneDisplay];
	}
}

#pragma mark -
#pragma mark SnSViewControllerLifeCycle

- (void) onRetrieveDisplayObjects:(UIView *)view
{
  [super onRetrieveDisplayObjects:view];
  
#ifdef __IPHONE_3_2
	if (IS_RUNNING_ON_IPAD)
  {
		
  }
#endif
  
  
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
  SnSLogD(@"willRotateToInterfaceOrientation");
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	//[self synchronizeDisplayObjects];
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	
	SnSLogE(@"didReceiveMemoryWarning in class : %@", [self class]);
}


@end
