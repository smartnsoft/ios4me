/* 
 * Copyright (C) 2009 Smart&Soft.
 * All rights reserved.
 *
 * The code hereby is the full property of Smart&Soft, SIREN 517 961 744.
 * http://www.smartnsoft.com - contact@smartnsoft.com
 * 
 * You are not allowed to use the source code or the resulting binary code, nor to modify the source code, without prior permission of the owner.
 */

//
//  SnSApplicationController.m
//  SnSFramework
//
//  Created by Édouard Mercier on 19/12/2009.
//

#import "SnSApplicationController.h"
#import "SnSLog.h"

#pragma mark -
#pragma mark SnSApplicationController

@implementation SnSApplicationController

+ (SnSApplicationController *) instance
{  
  static SnSApplicationController * _instance;
  @synchronized (self)
  {
    if (_instance == NULL)
    {
      _instance = [[self alloc] init];
    }
  }
  return _instance;
}

- (void) registerExceptionHandler:(id<SnSExceptionHandler>)theExceptionHandler
{
  exceptionHandler = theExceptionHandler;
}

- (void) registerInterceptor:(id<SnSViewControllerInterceptor>)theInterceptor
{
  interceptor = theInterceptor;
}

- (void) registerDecorator:(id<SnSViewDecorator>)theDecorator
{
	decorator = theDecorator;
}

- (void) onLifeCycleEvent:(UIViewController *)viewController onAggregate:(id<SnSViewControllerLifeCycle>)aggregate withEvent:(SnSInterceptorEvent)event
{
  if (interceptor != nil)
  {
    // We catch potential exceptions, in order to prevent the application from crashing
    @try
    {
      [interceptor onLifeCycleEvent:viewController onAggregate:aggregate withEvent:event];
    }
    // TOTHINK: maybe catch the ... exceptions also
    // TOTHINK: why not using the exception handler
    @catch (NSException * exception)
    {
      SnSLogEE(exception, @"A problem occurred while intercepting the event '%d'", event);
    }
  }
}

- (void) renderView:(UIViewController *)viewController onAggregate:(id<SnSViewControllerLifeCycle>)aggregate
{
	if (decorator != nil)
	{
		// We catch potential exceptions, in order to prevent the application from crashing
		@try
		{
			[decorator renderView:viewController onAggregate:aggregate];
		}
		@catch (NSException * exception)
		{
			SnSLogEE(exception, @"A problem occurred while rendering view '%@'", [viewController class]);
		}
	}
}

- (void) renderViewTableCell:(UITableViewCell *)viewCell
{
	if (decorator != nil)
	{
		// We catch potential exceptions, in order to prevent the application from crashing
		@try
		{
			[decorator renderViewTableCell:viewCell];
		}
		@catch (NSException * exception)
		{
			SnSLogEE(exception, @"A problem occurred while rendering table cell view '%@'", [viewCell class]);
		}
	}
}

/**
 * Regarding the introspection, apart from the documentation, a very good resource is available at http://theocacao.com/document.page/264
 * but also at http://blog.jayway.com/2009/03/06/proxy-based-aop-for-cocoa-touch .
 */
- (BOOL) handleException:(UIViewController *)viewController aggregate:(id<SnSViewControllerLifeCycle>)aggregate exception:(NSException *)exception resume:(BOOL *)resume
{
  if (exceptionHandler == nil)
  {
    return NO;
  }
  BOOL viewControllerMayHandleException = ([viewController conformsToProtocol:@protocol(SnSViewControllerExceptionHandler)] == YES);
  if ([exception isKindOfClass:[SnSBusinessObjectException class]] == YES)
  {
    if (viewControllerMayHandleException == YES && [viewController respondsToSelector:@selector(onBusinessObjectException:exception:resume:)] == YES)
    {
      SEL selector = @selector(onBusinessObjectException:exception:resume:);
      NSMethodSignature * methodSignature = [viewController methodSignatureForSelector:selector];
      NSInvocation * invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
      invocation.selector = selector;
      invocation.target = viewController;
      [invocation setArgument:&aggregate atIndex:2];
      [invocation setArgument:&exception atIndex:3];
      [invocation setArgument:&resume atIndex:4];
      [invocation invoke];
      BOOL hasBeenHandled;
      [invocation getReturnValue:&hasBeenHandled];
      if (hasBeenHandled == YES)
      {
        return YES;
      }
    }
    return [exceptionHandler onBusinessObjectException:viewController aggregate:aggregate exception:(SnSBusinessObjectException *)exception resume:resume];
  }
  else if ([exception isKindOfClass:[SnSLifeCycleException class]] == YES)
  {
    if (viewControllerMayHandleException == YES && [viewController respondsToSelector:@selector(onLifeCycleException:exception:resume:)] == YES)
    {
      SEL selector = @selector(onLifeCycleException:exception:resume:);
      NSMethodSignature * methodSignature = [viewController methodSignatureForSelector:selector];
      NSInvocation * invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
      invocation.selector = selector;
      invocation.target = viewController;
      [invocation setArgument:&aggregate atIndex:2];
      [invocation setArgument:&exception atIndex:3];
      [invocation setArgument:&resume atIndex:4];
      [invocation invoke];
      BOOL hasBeenHandled;
      [invocation getReturnValue:&hasBeenHandled];
      if (hasBeenHandled == YES)
      {
        return YES;
      }
    }    
    return [exceptionHandler onLifeCycleException:viewController aggregate:aggregate exception:(SnSBusinessObjectException *)exception resume:resume];
  }
  else
  {
    if (viewControllerMayHandleException == YES && [viewController respondsToSelector:@selector(onOtherException:exception:resume:)] == YES)
    {
      SEL selector = @selector(onOtherException:exception:resume:);
      NSMethodSignature * methodSignature = [viewController methodSignatureForSelector:selector];
      NSInvocation * invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
      invocation.selector = selector;
      invocation.target = viewController;
      [invocation setArgument:&aggregate atIndex:2];
      [invocation setArgument:&exception atIndex:3];
      [invocation setArgument:&resume atIndex:4];
      [invocation invoke];
      BOOL hasBeenHandled;
      [invocation getReturnValue:&hasBeenHandled];
      if (hasBeenHandled == YES)
      {
        return YES;
      }
		}
    return [exceptionHandler onOtherException:viewController aggregate:aggregate exception:(SnSBusinessObjectException *)exception resume:resume];
  }
}

- (BOOL) handleException:(id)sender exception:(NSException *)exception resume:(BOOL *)resume
{
  if (exceptionHandler == nil)
  {
    return NO;
  }
  return [exceptionHandler onException:sender exception:exception resume:resume];
}

- (void) performSelectorByHandlingException:(UIViewController *)viewController aggregate:(id<SnSViewControllerLifeCycle>)aggregate delegate:(SnSDelegate *)delegate
{
  @try
  {
    [delegate perform];
  }
  @catch (NSException * exception)
  {
    BOOL dummyResume;
    [self handleException:viewController aggregate:aggregate exception:exception resume:&dummyResume];
  }
}

#pragma mark -
#pragma mark NSObject

- (void) dealloc
{
  [super dealloc];
}

@end
