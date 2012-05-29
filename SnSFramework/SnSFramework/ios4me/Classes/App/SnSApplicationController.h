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

#import <Foundation/Foundation.h>

#import "SnSLifeCycle.h"
#import "SnSDelegate.h"

#pragma mark -
#pragma mark SnSViewControllerExceptionHandler

/**
 * When set on a UIViewController, indicates that it may be able to handle exceptions.
 */
@protocol SnSViewControllerExceptionHandler

@optional - (BOOL) onBusinessObjectException:(id<SnSViewControllerLifeCycle>)aggregate exception:(SnSBusinessObjectException *)exception resume:(BOOL *)resume;
@optional - (BOOL) onLifeCycleException:(id<SnSViewControllerLifeCycle>)aggregate exception:(SnSLifeCycleException *)exception resume:(BOOL *)resume;
@optional - (BOOL) onOtherException:(id<SnSViewControllerLifeCycle>)aggregate exception:(NSException *)exception resume:(BOOL *)resume;

@end

#pragma mark -
#pragma mark SnSExceptionHandler

/**
 * Receives all the framework exceptions in a single place.
 *
 * For each method, the return boolean indicates whether the exception has been handled by the protocol, and the last boolean pointer,
 * whether the life cycle of the underlying entity should be resumed or stopped.
 */
@protocol SnSExceptionHandler

/**
 * May be invoked when an exception is thrown from an object that is not a UIViewController.
 */
@optional - (BOOL) onException:(id)sender exception:(NSException *)exception resume:(BOOL *)resume;

- (BOOL) onBusinessObjectException:(UIViewController *)viewController aggregate:(id<SnSViewControllerLifeCycle>)aggregate exception:(SnSBusinessObjectException *)exception resume:(BOOL *)resume;
- (BOOL) onLifeCycleException:(UIViewController *)viewController aggregate:(id<SnSViewControllerLifeCycle>)aggregate exception:(SnSLifeCycleException *)exception resume:(BOOL *)resume;
- (BOOL) onOtherException:(UIViewController *)viewController aggregate:(id<SnSViewControllerLifeCycle>)aggregate exception:(NSException *)exception resume:(BOOL *)resume;

@end

#pragma mark -
#pragma mark SnSInterceptorEvent

/**
 * Defines all the interception events which correspond to the SnSViewControllerLifeCycle methods.
 */
typedef enum
{
  /**
   * Called just before the SnSViewControllerLifeCycle::onRetrieveDisplayObjects() method is called.
   */
  SnSInterceptorEventOnRetrieveDisplayObjects,
  /**
   * Called just after the SnSViewControllerLifeCycle::onRetrieveBusinessObjects() method has been called, provided no NSException exception has been thrown.
   */
  SnSInterceptorEventOnRetrieveBusinessObjects,
  /**
   * Called just after the SnSViewControllerLifeCycle::onFulfillDisplayObjects() method has been called, provided no NSException exception has been thrown.
   */
  SnSInterceptorEventOnFulfillDisplayObjects,
  /**
   * Called just after the SnSViewControllerLifeCycle::onSynchronizeDisplayObjects() method has been called, provided no NSException exception has been thrown.
   */
  SnSInterceptorEventOnSynchronizeDisplayObjects,
  /**
   * Called just before the SnSViewControllerLifeCycle::onDiscarded() method has been called.
   */
  SnSInterceptorEventOnDiscarded,
}
SnSInterceptorEvent;

#pragma mark -
#pragma mark SnSViewControllerInterceptor

/**
 * Receives all the SnSViewControllerLifeCycle life cycle events in a single place...
 */
@protocol SnSViewControllerInterceptor

- (void) onLifeCycleEvent:(UIViewController *)viewController onAggregate:(id<SnSViewControllerLifeCycle>)aggregate withEvent:(SnSInterceptorEvent)event;

@end

#pragma mark -
#pragma mark SnSViewDecorator

/**
 * In charge of adding, render a view.
 */
@protocol SnSViewDecorator

- (void) renderView:(UIViewController *)viewController onAggregate:(id<SnSViewControllerLifeCycle>)aggregate;
@optional - (void) renderViewTableCell:(UITableViewCell *)viewCell;

@optional - (UIView *)getCustomLoadingView;

@end

#pragma mark -
#pragma mark SnSApplicationController

/**
 * Is responsible for handling the application exceptions, and view controllers redirections.
 */
@interface SnSApplicationController : NSObject
{
	@private id<SnSViewControllerInterceptor> interceptor;
	@private id<SnSViewDecorator> decorator;
	@private id<SnSExceptionHandler> exceptionHandler;
}

+ (SnSApplicationController *) instance;

/**
 * Indicates the interceptor to use for handling all the SnSViewControllerLifeCycle entities events.
 */
- (void) registerInterceptor:(id<SnSViewControllerInterceptor>)theInterceptor;

/**
 * Indicates the decorator to use for design style of view.
 */
- (void) registerDecorator:(id<SnSViewDecorator>)theDecorator;

/**
 * Indicates the exception handler that will be queried when exceptions occur.
 */
- (void) registerExceptionHandler:(id<SnSExceptionHandler>)theExceptionHandler;

/**
 * Dispatches to the registered SnSViewControllerInterceptor (if any) the handling of the provided event.
 */
- (void) onLifeCycleEvent:(UIViewController *)viewController onAggregate:(id<SnSViewControllerLifeCycle>)aggregate withEvent:(SnSInterceptorEvent)event;

/**
 * Dispatches to the registered SnSViewDecorator (if any) the design of the current view.
 */
- (void) renderView:(UIViewController *)viewController onAggregate:(id<SnSViewControllerLifeCycle>)aggregate;

/**
 * Dispatches to the registered SnSViewDecorator (if any) the design of cell in tableView.
 */
- (void) renderViewTableCell:(UITableViewCell *)viewCell;

/**
 * Delegates to the registered SnSExceptionHandler the handling of the provided exception, that was triggered from a UIViewController.
 */
- (BOOL) handleException:(UIViewController *)viewController aggregate:(id<SnSViewControllerLifeCycle>)aggregate exception:(NSException *)exception resume:(BOOL *)resume;

/**
 * Delegates to the registered SnSExceptionHandler the handling of the provided exception, that was triggered from an object which is not a UIViewController.
 */
- (BOOL) handleException:(id)sender exception:(NSException *)exception resume:(BOOL *)resume;

/**
 * Executes a delegate, and if a NSException is thrown during its exception, delegates to the SnSExceptionHanlder the handing of the exception.
 */
- (void) performSelectorByHandlingException:(UIViewController *)viewController aggregate:(id<SnSViewControllerLifeCycle>)aggregate delegate:(SnSDelegate *)delegate;

@end
