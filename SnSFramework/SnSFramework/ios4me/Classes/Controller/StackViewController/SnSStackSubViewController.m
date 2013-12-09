//
//  SnSStackSubViewController.m
//  SnSFramework
//
//  Created by Johan Attali on 04/05/12.
//  Copyright 2012 Smart&Soft. All rights reserved.
//

#import "SnSStackSubViewController.h"
#import "SnSStackView.h"
#import "SnSLog.h"
#import "SnSConstants.h"
#import "SnSStackViewController.h"

#import <QuartzCore/QuartzCore.h>

#define VIEW_X(v)			((v).frame.origin.x)
#define VIEW_Y(v)			((v).frame.origin.y)
#define VIEW_WIDTH(v)		((v).frame.size.width)
#define VIEW_HEIGHT(v)		((v).frame.size.height)

@implementation SnSStackSubViewController

@synthesize framePortrait = _framePortrait;
@synthesize frameLandscape = _frameLandscape;
@synthesize stackController = _stackController;
@synthesize enablePan = _enablePan;

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
	
    self.shadowLayer = [CALayer layer];
    self.shadowLayer.shadowOpacity = 50.f;
    self.shadowLayer.shadowRadius = 7.f;
    self.shadowLayer.shadowOffset = CGSizeMake(0, 1);
    
	self.enablePan = YES;
    self.defaultShadow = NO;
    
    self.enableShadow = self.defaultShadow;
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

- (CGFloat)offsetShift
{
    return UIDeviceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]) ? self.offsetShiftPortrait : self.offsetShiftLandscape;
}

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
            aFutureFrame = (CGRect){aFutureFrame.origin.x - self.stackview.offsetShift,
                                        aFutureFrame.origin.y, aFutureFrame.size};
        
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

#pragma mark -
#pragma mark Utils
#pragma mark -

- (void)setEnableShadow:(BOOL)enableShadow
{
    if (enableShadow == _enableShadow)
        return ;
    
    self.shadowLayer.delegate = self.view.layer.delegate;
    self.shadowLayer.backgroundColor = self.view.layer.backgroundColor;
    self.shadowLayer.frame = (CGRect){CGPointZero, self.view.layer.frame.size};
    self.shadowLayer.shadowPath = [UIBezierPath bezierPathWithRect:self.shadowLayer.bounds].CGPath;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if ((_enableShadow = enableShadow))
            [self.view.layer insertSublayer:self.shadowLayer atIndex:0];
        else
            [self.shadowLayer removeFromSuperlayer];
    });
    
    self.view.clipsToBounds = (_enableShadow ? NO : YES);
}

#pragma mark - Basics -

- (void)dealloc
{
    self.shadowLayer = nil;
    
    [super dealloc];
}

@end
