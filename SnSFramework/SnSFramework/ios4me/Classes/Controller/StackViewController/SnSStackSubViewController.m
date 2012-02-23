//
//  SnSStackSubViewController.m
//  SnSFramework
//
//  Created by «FULLUSERNAME» on «DATE».
//  Copyright «YEAR» «ORGANIZATIONNAME». All rights reserved.
//

#import "SnSStackSubViewController.h"
#import "SnSStackView.h"

#define VIEW_X(v)			((v).frame.origin.x)
#define VIEW_Y(v)			((v).frame.origin.y)
#define VIEW_WIDTH(v)		((v).frame.size.width)
#define VIEW_HEIGHT(v)		((v).frame.size.height)

@implementation SnSStackSubViewController

@synthesize framePortrait = _framePortrait;
@synthesize frameLandscape = _frameLandscape;
@synthesize stackController = _stackController;

#pragma mark -
#pragma mark SnSStackSubViewController
#pragma mark -

- (void) updateDisplay
{
	
}

#pragma mark -
#pragma mark SnSViewControllerLifeCycle
#pragma mark -

/**
 * Called after the loadView call
 */
- (void) onRetrieveDisplayObjects:(UIView *)view
{
	[super onRetrieveDisplayObjects:view];
}

/**
 * Called after the viewDidLoad call
 */
- (void) onRetrieveBusinessObjects
{	
	[super onRetrieveBusinessObjects];
}

/**
 * Called after the viewWillAppear call
 */
- (void) onFulfillDisplayObjects
{
	[super onFulfillDisplayObjects];
	
}

/**
 * Called after the viewDidAppear call
 */
- (void) onSynchronizeDisplayObjects
{
	[super onSynchronizeDisplayObjects];
	
}

/**
 * Called after the viewDidUnload call
 */
- (void) onDiscarded
{
	[super onDiscarded];
}

#pragma mark -
#pragma mark Properties
#pragma mark -

- (SnSStackSubView *)stackview
{
    UIView* aView = self.view;
	
	if (![aView isKindOfClass:[SnSStackSubView class]])
	{
		UIView* aCurrentView = self.view;
		self.view = [aCurrentView viewConvertedToClass:[SnSStackSubView class]];
	}
    return (SnSStackSubView*)self.view;
}

#pragma mark -
#pragma mark UIViewController
#pragma mark -


- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	SnSLogD(@"");
    
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    if (!CGRectIsEmpty(self.stackview.framePortrait) && !CGRectIsEmpty(self.stackview.frameLandscape))
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:SnSStackAnimationDuration];
        
        // Take future frame 
        CGRect aFutureFrame = CGRectZero;
        if ( UIDeviceOrientationIsPortrait(toInterfaceOrientation))
            aFutureFrame = self.stackview.framePortrait;
        else
            aFutureFrame = self.stackview.frameLandscape;
        
        // Shift back frame if already shifted
        if ([_stackController isViewShifted:self.stackview])
            aFutureFrame = CGRectMake(aFutureFrame.origin.x-_stackController.offsetShift,
                                      aFutureFrame.origin.y,
                                      aFutureFrame.size.width,
                                      aFutureFrame.size.height);
        
        self.stackview.frame = aFutureFrame;
        
        [UIView commitAnimations];
    }
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	SnSLogD(@"");
    
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}

- (void)didReceiveMemoryWarning
{
	SnSLogW(@"");
	
	[super didReceiveMemoryWarning];
	
}


#pragma mark -
#pragma mark SnSViewControllerExceptionHandler
#pragma mark -

/*
 
 - (BOOL) onBusinessObjectException:(id<SnSViewControllerLifeCycle>)aggregate exception:(SnSBusinessObjectException *)exception resume:(BOOL *)resume;
 - (BOOL) onLifeCycleException:(id<SnSViewControllerLifeCycle>)aggregate exception:(SnSLifeCycleException *)exception resume:(BOOL *)resume;
 - (BOOL) onOtherException:(id<SnSViewControllerLifeCycle>)aggregate exception:(NSException *)exception resume:(BOOL *)resume;
 
 */





@end
