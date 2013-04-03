//
//  SnSStackViewController.m
//  SnSFramework
//
//  Created by Johan Attali on 04/05/12.
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

// Options
@synthesize canCoverMenu = canCoverMenu_;
@synthesize canMoveFreely = canMoveFreely_;
@synthesize enableGestures = enableGestures_;
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
	
	// -----------------------------
	// Default Member Values
	// -----------------------------
	self.offsetShift = SnSStackDefaultShift;
	self.canCoverMenu = NO;
	self.enableGestures = YES;
    
	// -----------------------------
	// Create the Pan Gesture Recognizer
	// -----------------------------
	UIPanGestureRecognizer* panRecognizer = [[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPanning:)] autorelease];
	[panRecognizer setDelegate:self];
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
#pragma mark Accessing Controllers
#pragma mark -

- (SnSStackSubViewController*)rootViewController
{
    return [_stackControllers firstObject];
}


#pragma mark -
#pragma mark SnSStackViewController
#pragma mark -

#pragma mark Panning

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
	BOOL shouldReceiveTouch = YES;
    
    if ([touch.view superviewOfClass:[SnSStackSubView class]] == nil)
        shouldReceiveTouch = NO;
	
	// List here all classes that should not receive a touch
	NSArray* classes = [NSArray arrayWithObjects:
                        NSStringFromClass([UISlider class]),
                        nil];
	
	for (NSString* strClass in classes)
	{
		Class cl = NSClassFromString(strClass);
        
        if ([touch.view superviewOfClass:cl] != nil)
            shouldReceiveTouch = NO;
	}

    return shouldReceiveTouch;
}

- (void)onPanning:(UIPanGestureRecognizer*)iRecognizer
{
	// No need to go further if panning is disable
	if (!self.enableGestures)
		return;
    
	// same thing is panning is disable for the receiver controller
	SnSStackSubViewController* movingController = [self controllerFromView:_panningStatus.viewMoving];
	if (movingController && movingController.isPanEnabled == NO)
		return;
	
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
    
    if (!movingController.view.layer.shadowColor)
        [movingController shadowEnabled:YES];

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
		CGFloat x = _panningStatus.initialFrame.origin.x+_panningStatus.displacement;
		
		// only allow x < 0 move if authorized to
		if (canMoveFreely_ || x >= 0)
		{
            // shift moving view
			[_panningStatus.viewMoving setFrame:CGRectMake(x,
														   VIEW_Y(_panningStatus.viewMoving),
														   VIEW_WIDTH(_panningStatus.viewMoving), 
														   VIEW_HEIGHT(_panningStatus.viewMoving))];
            
            // inform delegate view has moved
            if ([_delegate respondsToSelector:@selector(stackController:didMoveView:controller:direction:)])
            {
                [_delegate stackController:self
                               didMoveView:_panningStatus.viewMoving
                                controller:[self controllerFromView:_panningStatus.viewMoving]
                                 direction:_panningStatus.direction];
            }
		}
        
    }
	
	// -----------------------------
	// Gesture Ended: Post Mortem
	// -----------------------------
	if (iRecognizer.state == UIGestureRecognizerStateEnded || iRecognizer.state == UIGestureRecognizerStateCancelled) 
	{           
        UIView* viewMoving = _panningStatus.viewMoving;
        void (^viewShiftEnded)(BOOL) = ^(BOOL ended)
        {
            if (ended)
                [movingController shadowEnabled:NO];
        };        
        
		// Panning was left, restore view to original location
        // unless menu cover is allowed
		if (_panningStatus.direction == kPanningDirectionLeft)
        {
			CGFloat x = 0;
			
			// if can cover the menu we must check if other views
			// should be moved too
			if (canCoverMenu_ && VIEW_X(viewMoving) < VIEW_WIDTH(_menuView))
			{
				for (SnSStackSubViewController* c in _stackControllers)
				{
					UIView* viewToMove = c.view;
					
					if (viewToMove == _menuView)
						continue;
					
                    [self shiftView:viewToMove
                         toPosition:CGPointMake(0, VIEW_Y(viewToMove))
                         completion:viewShiftEnded];
				}
			}
			// menu is not covered so simply move back the moving view
			else
			{
				x = VIEW_X(viewMoving) -_panningStatus.displacement;
				
				[self shiftView:viewMoving
					 toPosition:CGPointMake(x, VIEW_Y(_panningStatus.viewMoving))
					   completion:viewShiftEnded];
			}
        }
		
		// Panning was right, either shift back or remove controller
		else if  (_panningStatus.direction == kPanningDirectionRight)
		{
			// view moved is outer : remove it
			if (_panningStatus.viewMoving == _outerView)
			{
				SnSStackSubViewController* controller = [self controllerFromView:_centerView];
				
				// do not automatically shift back center view if menu cover is activated
				if (!canCoverMenu_)
					[self shiftView:_centerView offset:_offsetShift animated:YES];
				
				// remove the current outer controller
				[self removeControllersFromController:controller animated:YES];
			}
			else
            {
                if (canCoverMenu_ && viewMoving == _centerView)
                    [self shiftViewToOrigin:_centerView animated:YES];
                else
                    [self shiftView:_panningStatus.viewMoving offset:-_panningStatus.displacement animated:YES];
            }
		}
        
        // inform delegate panning has ended
        if ([_delegate respondsToSelector:@selector(stackController:didEndPanOnView:controller:direction:)])
        {
            [_delegate stackController:self
                       didEndPanOnView:viewMoving
                            controller:[self controllerFromView:viewMoving]
                             direction:_panningStatus.direction];
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
    // take first controller if from controller is set to nil
    if (iFromController == nil)
        iFromController = [self rootViewController];
    
    // set stack controller
    iController.stackController = self;
    
    [self removeControllersFromController:iFromController animated:YES];
    
    // add its view to display
	[self.view addSubview:iController.view];
    [iController shadowEnabled:YES];
    
	
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
	[self shiftViewToOrigin:iController.stackview animated:iAnimated completion:^(BOOL ended)
     {
         if (canCoverMenu_ && VIEW_X(_centerView) < _offsetShift &&
             iController.stackview != _centerView && ended)
             [iController shadowEnabled:NO];
     }];
	
	// On iOS 4 and below the viewDidAppear was not triggered in non UIKit Controllers
	if ([[[UIDevice currentDevice] systemVersion] characterAtIndex:0] < '5')
	{
		[iController viewWillAppear:iAnimated];
		[iController viewDidAppear:iAnimated];
	}
    else
    {
        // set the new child controller
        [self addChildViewController:iController];
    }
    
  
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
			if ([_delegate respondsToSelector:@selector(stackController:willRemoveController:)])
				[_delegate stackController:self willRemoveController:aController];
            
			[self shiftView:aController.view
				 toPosition:CGPointMake(VIEW_WIDTH(self.view), VIEW_Y(aController.view))
                   animated:YES
				 completion:^(BOOL completed) {
                     // View hidden, disable shadow
                     [aController shadowEnabled:NO];
                     
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
    // only use the parent controlling system on devices > 5.0
    if ([[[UIDevice currentDevice] systemVersion] characterAtIndex:0] >= '5')
	    [iControllers makeObjectsPerformSelector:@selector(removeFromParentViewController)];

    
	[_stackControllers removeObjectsInArray:iControllers];
}

- (void)popCurrentController
{
    if (_stackControllers.count > 2)
    {
        SnSStackSubViewController* c = [_stackControllers objectAtIndex:_stackControllers.count-2];
        
        [self removeControllersFromController:c animated:YES];
    }
}

#pragma mark Accessing Inner Views/Controllers

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

- (SnSStackSubViewController*)controllerFromView:(UIView*)iView
{
	SnSStackSubViewController* foundController = nil;
	for (SnSStackSubViewController* controller in _stackControllers)
	{
		if (controller.view == iView)
		{
			foundController = controller;
			break;
		}
	}
	
	return foundController;
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
    SnSStackSubViewController* controller = [self controllerFromView:iView];
    
    [UIView animateWithDuration:iAnimated ? SnSStackAnimationDuration : 0
     
                     animations:^{
                         if (!controller.view.layer.shadowColor)
                             [controller shadowEnabled:YES];
                         
                         [iView setFrame:CGRectMake(iPos.x, iPos.y, VIEW_WIDTH(iView), VIEW_HEIGHT(iView))];
                     }
     
                     completion:^(BOOL done){
                        if (done && iPos.x == 0)
                            [controller shadowEnabled:NO];
                     }];
}

- (void)shiftView:(UIView *)iView toPosition:(CGPoint)iPos animated:(BOOL)iAnimated completion:(void(^)(BOOL))iBlock
{
    SnSStackSubViewController* controller = [self controllerFromView:iView];

	[UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
	[UIView animateWithDuration:(iAnimated ? SnSStackAnimationDuration : .0f)
     
					 animations:^{
                         if (!controller.view.layer.shadowColor)
                             [controller shadowEnabled:YES];

                         [iView setFrame:CGRectMake(iPos.x, iPos.y, VIEW_WIDTH(iView), VIEW_HEIGHT(iView))];
                     }
     
					 completion:^(BOOL done){
                         if (done && iPos.x == 0)
                             [controller shadowEnabled:NO];
                         
                         if (iBlock)
                             iBlock(done);
                     }];
}

- (void)shiftView:(UIView*)iView toPosition:(CGPoint)iPos completion:(void(^)(BOOL))iBlock
{
	[self shiftView:iView toPosition:iPos animated:YES completion:iBlock];
}

- (void)shiftViewToOrigin:(SnSStackSubView *)iView animated:(BOOL)iAnimated
{
    [self shiftViewToOrigin:iView animated:iAnimated completion:nil];
}

- (void)shiftViewToOrigin:(SnSStackSubView *)iView animated:(BOOL)iAnimated completion:(void(^)(BOOL))iBlock
{
	CGRect aFrame = iView.frame;
    
    if ([iView isKindOfClass:[SnSStackSubView class]])
    {
        if (UIDeviceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]))
            aFrame = iView.framePortrait;
        else
            aFrame = iView.frameLandscape;
    }
	
	// now if we can cover the menu and its already covered shift also from offset
	if (canCoverMenu_ && VIEW_X(_centerView) < _offsetShift && iView != _centerView)
		[self shiftView:iView toPosition:CGPointMake(0, VIEW_Y(iView)) animated:iAnimated completion:iBlock];
	
	// Start by shifting the view to its original position
	else
		[self shiftView:iView toPosition:aFrame.origin  animated:iAnimated completion:iBlock];
}

- (void)shiftView:(UIView *)iView offset:(NSInteger)iOffset animated:(BOOL)iAnimated
{
	[self shiftView:iView toPosition:CGPointMake(VIEW_X(iView) + iOffset, VIEW_Y(iView)) animated:iAnimated];
}


@end
