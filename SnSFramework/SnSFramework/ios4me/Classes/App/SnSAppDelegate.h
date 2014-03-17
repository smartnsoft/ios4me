
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

#import "SnSApplicationController.h"

#define kTagActivityIndicatorLoadingView 1

@class SnSAppWindow;

/**
 * An iPhone application delegate which proposes additional services.
 *
 * The <code>- (void) applicationDidFinishLaunching:(UIApplication *)application</code> method should not be overloaded,
 * and only the methods overriden.
 */
@interface SnSAppDelegate : NSObject<UIApplicationDelegate>
{
  UIWindow * window;
  @private UIView * loadingView;
}

/**
 * The window of the application.
 */
@property (nonatomic, retain) UIWindow * window;

/**
 * The loading view, displayed when some loading is pending.
 */
@property (nonatomic, retain) UIView * loadingView;

/**
 * Invoked at the start of the application delegate, in order to determine the application exception handler.
 *
 * By default, no exception handler is associated.
 */
- (id<SnSExceptionHandler>) getExceptionHandler;

/**
 * A hook for intercepting the aggregates life cycle events.
 */
- (id<SnSViewControllerInterceptor>) getInterceptor;

/**
 * Decorator for default design of all components of views
 */
- (id<SnSViewDecorator>) getDecorator;

/**
 * Indicates that some pending action by displaying a greyed modal view on top of the current view.
 *
 * Loading actions can be stacked.
 *
 * @param sender the object sending the notification
 * @param message the message which explains why the loading is running. May be <code>nil</code>
 */
+ (void) startLoading:(id)sender withMessage:(NSString *)message;

/**
 * Indicates that a previous loading action is now over.
 *
 * @param sender the object sending the notification
 */
+ (void) stopLoading:(id)sender;

/**
 * Is invoked when starting the application.
 *
 * @return the application starting view controller.
 */
- (UIViewController *) getStartingViewController;

/**
 * Is invoked at the start of the <code>- (void) applicationDidFinishLaunching:(UIApplication *)application</code> method.
 *
 * At this point, the UIWindow has not been even created.
 *
 * @see #onApplicationDidFinishLaunchingEnd
 
 */
- (void)onApplicationDidFinishLaunchingBegin:(UIApplication *)application;

/**
 * Is invoked at the end of the <code>- (void) applicationDidFinishLaunching:(UIApplication *)application</code> method.
 *
 * At this point, the initialization is over, and in particular, the application UIWindow is visible.
 *
 * @see #onApplicationDidFinishLaunchingBegin
 */
- (void)onApplicationDidFinishLaunchingEnd:(UIApplication *)application;

@end
