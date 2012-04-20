//
//  SnSStackViewController.m
//  SnSFramework
//
//  Created by Johan Attali on «DATE».
//  Copyright 2012 Smart&Soft. All rights reserved.
//

// View Controllers
#import "SnSStackViewController.h"
#import "SnSStackSubViewController.h"

// Views
#import "SnSStackView.h"

#define VIEW_X(v)			((v).frame.origin.x)
#define VIEW_Y(v)			((v).frame.origin.y)
#define VIEW_WIDTH(v)		((v).frame.size.width)
#define VIEW_HEIGHT(v)		((v).frame.size.height)

@implementation SnSStackViewController

@synthesize offsetShift = _offsetShift;
@synthesize delegate = _delegate;

//@synthesize menuView = _menuView;

#pragma mark -
#pragma mark SnSStackViewController
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
	
	self.offsetShift = SnSStackDefaultShift;
	
	// -----------------------------
	// Create the Pan Gesture Recognizer
	// -----------------------------
	UIPanGestureRecognizer* panRecognizer = [[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPanning:)] autorelease];
	[panRecognizer setMaximumNumberOfTouches:1];
	[panRecognizer setDelaysTouchesBegan:TRUE];
	[panRecognizer setDelaysTouchesEnded:TRUE];
	[panRecognizer setCancelsTouchesInView:TRUE];
	
	[self.view addGestureRecognizer:panRecognizer];

}

/**
 * Called after the viewDidLoad call
 */
- (void) onRetrieveBusinessObjects
{	
	[super onRetrieveBusinessObjects];
	
	self.view.clipsToBounds = YES;
	
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
#pragma mark UIViewController
#pragma mark -


#pragma mark Basics

// Use the designated initalizer to do nececarry setup
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
	{
		// If user forgot to set the view to be a SnSStackView replace the current view
		// with a newly allolcated SnSStackView
		if (![self.view isKindOfClass:[SnSStackView class]])
		{
			UIView* aCurrentView = self.view;
			self.view = [aCurrentView viewConvertedToClass:[SnSStackView class]];
		}
	}
	
	return self;
}

- (void)dealloc
{
	[_stackControllers release];
	
	[super dealloc];
}

- (void)didReceiveMemoryWarning
{
	SnSLogW(@"");
	
	[super didReceiveMemoryWarning];
	
}

#pragma mark -
#pragma mark Rotations
#pragma mark -


- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	SnSLogD(@"");
    for (UIViewController* aController in _stackControllers)
        [aController willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	SnSLogD(@"");
    for (UIViewController* aController in _stackControllers)
        [aController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}



#pragma mark -
#pragma mark Properties
#pragma mark -

- (void)setStackControllers:(NSArray *)stackControllers
{
	if ([stackControllers count] > 0)
	{
		SnSReleaseAndNil(_stackControllers);
		
		_stackControllers = [[NSMutableArray alloc] initWithArray:stackControllers];
		
		// Remove all previous views
		for (UIView* aSubView in [self.view subviews])
			[aSubView removeFromSuperview];
		
		// The menu view is always the view of the first stack controller
		_menuView = [[_stackControllers objectAtIndex:0] view];
		
		// The center view is the second view controller if given
		_centerView =[_stackControllers count] > 1 ?  (SnSStackSubView*)[[_stackControllers objectAtIndex:1] view] : nil;
		
		// Add the new views
		for (SnSStackSubViewController* aController in _stackControllers)
		{
			if (aController.view)
				[self.view addSubview:aController.view];
			
			// Readjust Frame if needed
			if (aController.stackview == _menuView)
			{
				aController.stackview.frame = CGRectMake(VIEW_X(aController.stackview), 
														 VIEW_Y(aController.stackview),
														 VIEW_WIDTH(aController.stackview),
														 VIEW_HEIGHT(self.view));
			}
			
			// Set default portrait/landscape frames if not given
			if ([aController.stackview isKindOfClass:[SnSStackSubView class]])
			{
				if (CGRectIsEmpty(aController.stackview.framePortrait) && CGRectIsEmpty(aController.stackview.frameLandscape) )
				{
					aController.stackview.framePortrait = aController.stackview.frame;
					aController.stackview.frameLandscape = aController.stackview.frame;
					
				}
			}
			
			
			// Move controller to their initial position
			[self shiftViewToOrigin:aController.stackview animated:NO];
		}
	}
	
}

- (NSArray*)stackControllers
{
	return _stackControllers;
}




#pragma mark -
#pragma mark SnSStackViewController
#pragma mark -

#pragma mark Callbacks

- (void)onPanning:(UIPanGestureRecognizer*)iRecognizer
{
	_panningStatus.location = [iRecognizer locationInView:self.view];

	// -----------------------------
	// Gesture Began: Setup
	// -----------------------------
	if (iRecognizer.state == UIGestureRecognizerStateBegan) 
	{
		_panningStatus.direction	= kPanningDirectionUnkown;
		_panningStatus.displacement = 0;
		_panningStatus.hitLocation	= _panningStatus.location;
		_panningStatus.lastLocation = _panningStatus.location;
		_panningStatus.viewMoving	= _outerView ? _outerView : _centerView;
		_panningStatus.initialFrame	= _panningStatus.viewMoving.frame;
	}
	
	
	// -----------------------------
	// Determining Panning Direction
	// -----------------------------
	if (_panningStatus.location.x > _panningStatus.lastLocation.x)
		_panningStatus.direction = kPanningDirectionRight;
	else if (_panningStatus.location.x < _panningStatus.lastLocation.x)
		_panningStatus.direction = kPanningDirectionLeft;

	// -----------------------------
	// Updating Displacement values
	// -----------------------------
	_panningStatus.displacement = _panningStatus.location.x - _panningStatus.hitLocation.x ;
	_panningStatus.lastLocation = _panningStatus.location;
	
	// -----------------------------
	// Handling View Moving
	// -----------------------------
	if (iRecognizer.state == UIGestureRecognizerStateChanged &&
		_panningStatus.viewMoving != nil &&
		_panningStatus.direction != kPanningDirectionUnkown) 
	{
		[_panningStatus.viewMoving setFrame:CGRectMake(_panningStatus.initialFrame.origin.x+_panningStatus.displacement,
													   VIEW_Y(_panningStatus.viewMoving),
													   VIEW_WIDTH(_panningStatus.viewMoving), 
													   VIEW_HEIGHT(_panningStatus.viewMoving))];
	}
	
	// -----------------------------
	// Gesture Ended: Post Mortem
	// -----------------------------
	if (iRecognizer.state == UIGestureRecognizerStateEnded || iRecognizer.state == UIGestureRecognizerStateCancelled) 
	{
		// Panning was left, restore view to original location
		if (_panningStatus.direction == kPanningDirectionLeft)
			[self shiftView:_panningStatus.viewMoving offset:-_panningStatus.displacement animated:YES];
		
		// Panning was right, either shift back or remove controller
		else if  (_panningStatus.direction == kPanningDirectionRight)
		{
			if (_panningStatus.viewMoving == _outerView)
			{
				UIViewController* aCenterController = [self controllerFromView:_centerView];
				[self shiftView:_centerView offset:_offsetShift animated:YES];
				[self removeControllersFromController:aCenterController animated:YES];
			}
			else
				[self shiftView:_panningStatus.viewMoving offset:-_panningStatus.displacement animated:YES];
		}
	}
	
	
	
	NSString* aPanningInfo = [NSString stringWithFormat:@"Panning: view: %@ - location: (%.0f %.0f) - direction:%d - displacement:%d -",
							  _panningStatus.viewMoving,
							  _panningStatus.location.x,_panningStatus.location.y,
							  _panningStatus.direction,
							  _panningStatus.displacement];
	
	SnSLogD(aPanningInfo);
		
}



#pragma mark Adding/Removing Controllers

- (void)pushStackController:(SnSStackSubViewController*)iController fromController:(UIViewController*)iFromController animated:(BOOL)iAnimated
{
	[self removeControllersFromController:iFromController animated:YES];
	
	// add its view to display
	[self.view addSubview:iController.view];
	
	// Set default location if not provided
	if (CGRectIsEmpty(iController.stackview.framePortrait) || CGRectIsEmpty(iController.stackview.frameLandscape))
	{
		CGRect aDefaultFrame	= iController.view.frame;
		
		if ([_stackControllers count] >= 2)
			aDefaultFrame = CGRectMake(VIEW_WIDTH(self.view) - VIEW_WIDTH(iController.view), 0, VIEW_WIDTH(iController.view), VIEW_HEIGHT(self.view));
		else if ([_stackControllers count] == 1)
			aDefaultFrame = CGRectMake(VIEW_WIDTH(_menuView), 0, VIEW_WIDTH(iController.view), VIEW_HEIGHT(self.view));
		
		iController.stackview.frame				= aDefaultFrame;
		iController.stackview.framePortrait		= iController.stackview.frame;
		iController.stackview.frameLandscape	= iController.stackview.frame;

	}
	
	
	// Setup is done, retain the controller in the stack
	[_stackControllers addObject:iController];
	
	SnSStackSubView* aOldCenterView = _centerView;
	SnSStackSubView* aOldOuterView = _outerView;
	
	// Update view order
	[self updateInnerViews];
	
	// Only shift once
	if (![self isViewShifted:aOldCenterView])
		[self shiftView:aOldCenterView offset:-self.offsetShift animated:YES];
	
	if (![self isViewShifted:aOldOuterView])
		[self shiftView:aOldOuterView offset:-self.offsetShift animated:YES];	
	
	
	
	// If animation is wanted, start by putting the controller to the extra edge of the master view
	if (iAnimated)
	{
		[self shiftView:iController.stackview
			 toPosition:CGPointMake(VIEW_WIDTH(self.view), VIEW_Y(iController.stackview))
			   animated:NO];
	}
	
	// Next move the controller to its origin position
	[self shiftViewToOrigin:iController.stackview animated:iAnimated];
	

}

- (void)removeControllersFromController:(UIViewController *)iController animated:(BOOL)iAnimated
{
	if (iController != [_stackControllers lastObject])
	{
		NSMutableArray* aArray = [[[NSMutableArray alloc] initWithCapacity:[_stackControllers count]] autorelease];
		BOOL aControllerFound = NO;
		for (SnSStackSubViewController* aController in _stackControllers)
		{
			if (aControllerFound)
				[aArray addObject:aController];
			
			if (aController == iController)
				aControllerFound = YES;
		}
		
		for (SnSStackSubViewController* aController in aArray)
		{
			// Inform delegate removal is about to start
			if ([_delegate respondsToSelector:@selector(willRemoveSnSStackSubController:)])
				[_delegate willRemoveSnSStackSubController:aController];
				
			[self shiftView:aController.view 
				 toPosition:CGPointMake(VIEW_WIDTH(self.view), VIEW_Y(aController.view)) 
				 completion:^(BOOL completed) {
					 [aController.view removeFromSuperview];
					 
					 // if the last controller is a tableview controller we must delect it's current row
					 // TODO: add also a delegate with the didRemoveController ...
					 SnSStackTableSubViewController* aLastController = [_stackControllers lastObject];
					 if ([aLastController isKindOfClass:[SnSStackTableSubViewController class]])
						 [aLastController.tableView deselectRowAtIndexPath:[aLastController.tableView indexPathForSelectedRow]
																  animated:YES];
					 
				 }];
		}
		
		[self removeControllers:aArray];
		
		if (aControllerFound)
		{			
			// Since we removed at least one controller, 
			// we must update the inner view to refresh the stack controller content
			[self updateInnerViews];
		}
			

	}

		
		
}

- (void)removeControllers:(NSArray *)iControllers
{
	[_stackControllers removeObjectsInArray:iControllers];
}

- (void)updateInnerViews
{
	SnSStackSubViewController* aLastController = [_stackControllers lastObject];
	
	if ([_stackControllers count] == 2)
	{
		_centerView = aLastController.stackview;
		_outerView = nil;
	}
	else if ([_stackControllers count] > 2)
	{
		SnSStackSubViewController* aPreviousController = [_stackControllers objectAtIndex:[_stackControllers count] - 2];
		_outerView = aLastController.stackview;
		_centerView = aPreviousController.stackview;
	}
}

- (UIViewController*)controllerFromView:(UIView*)iView
{
	UIViewController* aFoundController = nil;
	for (UIViewController* aController in _stackControllers)
	{
		if (aController.view == iView)
		{
			aFoundController = aController;
			break;
		}
	}
	
	return aFoundController;
}


#pragma mark Shifting

- (BOOL)isViewShifted:(SnSStackSubView *)iView
{
	CGFloat aOriginX = SnSOrientationDependWithOrientation([[UIApplication sharedApplication] statusBarOrientation],
                                                      iView.framePortrait.origin.x, 
                                                      iView.frameLandscape.origin.x);
    
    // Views repositionning can shift from a ocuple of pixels
	return abs(VIEW_X(iView) - aOriginX) > 2;
}

- (void)shiftView:(UIView *)iView toPosition:(CGPoint)iPos animated:(BOOL)iAnimated
{
	if (iAnimated)
	{
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDuration:SnSStackAnimationDuration];
	}
	
	[iView setFrame:CGRectMake(iPos.x, iPos.y, VIEW_WIDTH(iView), VIEW_HEIGHT(iView))];
	
	if (iAnimated)
		[UIView commitAnimations];
	
}

- (void)shiftView:(UIView*)iView toPosition:(CGPoint)iPos completion:(void(^)(BOOL))iBlock
{
	[UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
	[UIView animateWithDuration:SnSStackAnimationDuration 
					 animations:^{ [iView setFrame:CGRectMake(iPos.x, iPos.y, VIEW_WIDTH(iView), VIEW_HEIGHT(iView))]; }
					 completion:iBlock];
}

- (void)shiftViewToOrigin:(SnSStackSubView *)iView animated:(BOOL)iAnimated
{
	CGRect aFrame = iView.frame;
    
    if ([iView isKindOfClass:[SnSStackSubView class]])
    {
        if (UIDeviceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]))
            aFrame = iView.framePortrait;
        else
            aFrame = iView.frameLandscape;

    }
	
	[self shiftView:iView toPosition:aFrame.origin  animated:iAnimated];
}

- (void)shiftView:(UIView *)iView offset:(NSInteger)iOffset animated:(BOOL)iAnimated
{
	[self shiftView:iView toPosition:CGPointMake(VIEW_X(iView) + iOffset, VIEW_Y(iView)) animated:iAnimated];
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
