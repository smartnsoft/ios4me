/*
 * (C) Copyright 2009-2011 Smart&Soft SAS (http://www.smartnsoft.com/) and contributors.
 *
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the GNU Lesser General Public License
 * (LGPL) version 3.0 which accompanies this distribution, and is available at
 * http://www.gnu.org/licenses/lgpl.html
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * Lesser General Public License for more details.
 *
 * Contributors:
 *     Smart&Soft - initial API and implementation
 */

#import <UIKit/UIKit.h>
#import "SnSViewController.h"

@class SnSStackSubViewController;
@class SnSStackSubView;
@class SnSStackViewController;

typedef enum SnSStackViewDirection {
    kPanningDirectionUnkown		= +0,
    kPanningDirectionLeft		= -1,
    kPanningDirectionRight		= +1
}SnSStackViewDirection;

typedef struct SnSStackPanningStatus
{
	UIView*		viewMoving;
	NSInteger	displacement;
	CGPoint		location;
	CGPoint		hitLocation;
	CGPoint		lastLocation;
	CGRect		initialFrame;
	SnSStackViewDirection direction;
	
} SnSStackPanningStatus;

@protocol SnSStackViewControllerDelegate <NSObject>

@optional

/**
 * This is sent when the view is actually being panned.
 * @param stackController   The master stack controller handling the panning
 * @param view              The view that was being moved
 * @param controller        The controller attached to the view
 * @param direction         The direction where the view is being moved
 */
- (void)stackController:(SnSStackViewController*)stackController
            didMoveView:(UIView*)view
             controller:(SnSStackSubViewController*)subController
              direction:(SnSStackViewDirection)direction;

/**
 * This is sent before when the stack view controller is done with the panning gesture
 * @param stackController   The master stack controller handling the panning
 * @param view              The view that was being moved
 * @param controller        The controller attached to the view
 * @param direction         The direction where the view is being moved
 */
- (void)stackController:(SnSStackViewController*)stackController
        didEndPanOnView:(UIView*)view
             controller:(SnSStackSubViewController*)subController
              direction:(SnSStackViewDirection)direction;


/**
 * This is sent before the stack view controller is deleted from the _stackController list
 * @param iController The controller that is beeing removed from the stack controllers
 */
- (void)stackController:(SnSStackViewController*)stackController
   willRemoveController:(SnSStackSubViewController*)subController;

@end


@interface SnSStackViewController : SnSViewController <UIGestureRecognizerDelegate>
{
	NSMutableArray* _stackControllers;
	
	UIView* _menuView;
	SnSStackSubView* _centerView;
	SnSStackSubView* _outerView;
	
	NSInteger _offsetShit;
	
	SnSStackPanningStatus _panningStatus;
	
	// Delegate
	id<SnSStackViewControllerDelegate> _delegate;
	
	// Options
    BOOL canCoverMenu_;
	BOOL canMoveFreely_;
	BOOL enableGestures_;

}

@property (nonatomic, retain) NSArray* stackControllers;
@property (nonatomic, assign) NSInteger offsetShift;
@property (nonatomic, retain) id<SnSStackViewControllerDelegate> delegate;

// Options
@property (nonatomic, assign) BOOL canCoverMenu;
@property (nonatomic, assign) BOOL canMoveFreely;
@property (nonatomic, assign) BOOL enableGestures;

#pragma mark Callbacks

- (void)onPanning:(UIPanGestureRecognizer*)iSender;

#pragma mark Shifting Controllers

- (void)shiftViewToOrigin:(SnSStackSubView*)iView animated:(BOOL)iAnimated completion:(void(^)(BOOL))iBlock;
- (void)shiftViewToOrigin:(SnSStackSubView*)iView animated:(BOOL)iAnimated;
- (void)shiftView:(UIView*)iView toPosition:(CGPoint)iPos animated:(BOOL)iAnimated;
- (void)shiftView:(UIView*)iView toPosition:(CGPoint)iPos animated:(BOOL)iAnimated completion:(void(^)(BOOL))iBlock;
- (void)shiftView:(UIView*)iView toPosition:(CGPoint)iPos completion:(void(^)(BOOL))iBlock;
- (void)shiftView:(UIView*)iView offset:(NSInteger)iOffset animated:(BOOL)iAnimated;
- (BOOL)isViewShifted:(SnSStackSubView*)iView;

#pragma mark Accessing Controllers

- (SnSStackSubViewController*)rootViewController;

#pragma mark Adding/Removing Controllers

/*! 
 * Updates the internal view pointers (eg _centerView, _outerView)
 * based on the last controller in the stack
 */
- (void)updateInnerViews;

/*! 
 * Returns the view controller holding the view given in paremeter
 * @param	iView	The view to test
 * @return	The controller having iView as it's view content or nil if not found
 */
- (SnSStackSubViewController*)controllerFromView:(UIView*)iView;

/*!
 * Removes the current controller from the stack and present the previous one
 */
- (void)popCurrentController;

/*! 
 * If a user selects pushes a new controller from an existing controller (not the last one)
 * we must unstack all previous controllers and remove them from controller list
 */
- (void)removeControllersFromController:(UIViewController*)iController animated:(BOOL)iAnimated;
- (void)removeControllers:(NSArray*)iController;
- (void)pushStackController:(SnSStackSubViewController*)iController fromController:(UIViewController*)iController animated:(BOOL)iAnimated;


@end
