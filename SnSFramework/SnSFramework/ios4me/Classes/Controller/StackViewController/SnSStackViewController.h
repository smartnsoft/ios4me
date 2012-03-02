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

@class SnSStackSubViewController;
@class SnSStackSubView;

typedef struct SnSStackPanningStatus
{
	UIView*		viewMoving;
	NSInteger	displacement;
	CGPoint		location;
	CGPoint		hitLocation;
	CGPoint		lastLocation;
	CGRect		initialFrame;
	enum 
	{
		kPanningDirectionUnkown		= +0,
		kPanningDirectionLeft		= -1,
		kPanningDirectionRight		= +1
	}direction;
	
} SnSStackPanningStatus;

@protocol SnSStackViewControllerDelegate <NSObject>

@optional

/**
 * This is sent before the stack view controller is deleted from the _stackController list
 * @param iController The controller that is beeing removed from the stack controllers
 */
- (void)willRemoveSnSStackSubController:(SnSStackSubViewController*)iController;

@end


@interface SnSStackViewController : SnSViewController 
{
	NSMutableArray* _stackControllers;
	
	UIView* _menuView;
	SnSStackSubView* _centerView;
	SnSStackSubView* _outerView;
	
	NSInteger _offsetShit;
	
	SnSStackPanningStatus _panningStatus;
	
	// Delegate
	id<SnSStackViewControllerDelegate> _delegate;

}

@property (nonatomic, retain) NSArray* stackControllers;
@property (nonatomic, assign) NSInteger offsetShift;
@property (nonatomic, retain) id<SnSStackViewControllerDelegate> delegate;

#pragma mark Callbacks

- (void)onPanning:(UIPanGestureRecognizer*)iSender;

#pragma mark Shifting Controllers

- (void)shiftViewToOrigin:(SnSStackSubView*)iView animated:(BOOL)iAnimated;
- (void)shiftView:(UIView*)iView toPosition:(CGPoint)iPos completion:(void(^)(BOOL))iBlock;
- (void)shiftView:(UIView*)iView toPosition:(CGPoint)iPos animated:(BOOL)iAnimated;
- (void)shiftView:(UIView*)iView offset:(NSInteger)iOffset animated:(BOOL)iAnimated;
- (BOOL)isViewShifted:(SnSStackSubView*)iView;

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
- (UIViewController*)controllerFromView:(UIView*)iView;

/*! 
 * If a user selects pushes a new controller from an existing controller (not the last one)
 * we must unstack all previous controllers and remove them from controller list
 */
- (void)removeControllersFromController:(UIViewController*)iController animated:(BOOL)iAnimated;
- (void)removeControllers:(NSArray*)iController;
- (void)pushStackController:(SnSStackSubViewController*)iController fromController:(UIViewController*)iController animated:(BOOL)iAnimated;

@end
