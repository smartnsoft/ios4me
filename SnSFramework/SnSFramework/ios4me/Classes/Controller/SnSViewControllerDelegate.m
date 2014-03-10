//
//  SnSMasterViewController.m
//  SnSFramework
//
//  Created by Johan Attali on 09/09/11.
//  Copyright 2011 Smart&Soft. All rights reserved.
//
//	The code hereby is the full property of Smart&Soft, SIREN 517 961 744.
//	http://www.smartnsoft.com - contact@smartnsoft.com
//

#import "SnSViewControllerDelegate.h"
#import "SnSApplicationController.h"
#import "SnSLog.h"
#import "SnSConstants.h"
#import "NSObject+SnSExtension.h"

@interface SnSViewControllerDelegate (Private)

- (BOOL)isBusinessObjectsRetrievalAsynchronous:(id)aggregate;
- (void)onRetrieveDisplayObjectsInternal:(UIView*)view;
- (BOOL)onRetrieveBusinessObjectsInternal:(NSNumber*)index;
- (void)onBusinessObjectsRetrieved:(id)aggregate atIndex:(NSUInteger)index;
- (void)onFulfillDisplayObjectsInternalAsynchronous:(id)object;
- (void)onSynchronizeDisplayObjectsInternalAsynchronous:(id)object;
- (BOOL)onFulfillDisplayObjectsInternal:(id)aggregate atIndex:(NSUInteger)index;
- (BOOL)onSynchronizeDisplayObjectsInternal:(id)aggregate atIndex:(NSUInteger)index;
- (void)onDiscardedInternal;

@end

@implementation SnSViewControllerDelegate (Private)

- (BOOL)isBusinessObjectsRetrievalAsynchronous:(id)aggregate
{
	return [aggregate conformsToProtocol:@protocol(SnsBusinessObjectsRetrievalAsynchronousPolicy)];
}

- (void)onRetrieveDisplayObjectsInternal:(UIView*)view
{
	NSUInteger index = 0;
	id<SnSViewControllerLifeCycle> aggregate = aggregator;
	//for (id<SnSViewControllerLifeCycle> aggregate in aggregates)
//	{
		@try
		{
			[[SnSApplicationController instance] onLifeCycleEvent:aggregator 
													  onAggregate:(aggregator == aggregate ? nil : aggregate)
														withEvent:SnSInterceptorEventOnRetrieveDisplayObjects];
			
			[aggregate onRetrieveDisplayObjects:view];
			
			[[SnSApplicationController instance] renderView:aggregator
												onAggregate:(aggregator == aggregate ? nil : aggregate)];
		}
		@catch (NSException* exception)
		{
			SnSLogEW(exception, @"Could not properly retrieve the display objects");
			[[SnSApplicationController instance] handleException:aggregator 
													   aggregate:(aggregator == aggregate ? nil : aggregate)
													   exception:exception
														  resume:&(statuses[index])];
		}
		index++;
//	}
}

- (BOOL)onRetrieveBusinessObjectsInternal:(NSNumber*)index
{
	NSUInteger plainIndex = [index unsignedIntegerValue];
	if (statuses[plainIndex] == NO)
		return NO;
	
	
	id<SnSViewControllerLifeCycle> aggregate = aggregator; //[aggregates objectAtIndex:plainIndex];
	@try
	{
		
		[aggregate onRetrieveBusinessObjects];
		[[SnSApplicationController instance] onLifeCycleEvent:aggregator 
												  onAggregate:(aggregator == aggregate ? nil : aggregate)
													withEvent:SnSInterceptorEventOnRetrieveBusinessObjects];
	}
	@catch (NSException* exception)
	{
		SnSLogEW(exception, @"Could not properly retrieve the business objects");
		[[SnSApplicationController instance] handleException:aggregator 
												   aggregate:(aggregator == aggregate ? nil : aggregate)
												   exception:exception 
													  resume:&(statuses[plainIndex])];
	}
	if (statuses[plainIndex] == YES)
		[self onBusinessObjectsRetrieved:aggregate atIndex:plainIndex];
	
	return statuses[plainIndex];
}

- (void)onBusinessObjectsRetrieved:(id)aggregate atIndex:(NSUInteger)index
{  
	// ASYNC mode
	if ([self isBusinessObjectsRetrievalAsynchronous:aggregate] == YES)
	{
		// We invoke the two methods in the GUI thread
		id arrayObject = [NSArray arrayWithObjects:aggregate, [NSNumber numberWithUnsignedInteger:index], nil];
		// We retain twice the array, because it will be released twice
//		[arrayObject retain];
		
		[self performSelectorOnMainThread:@selector(onFulfillDisplayObjectsInternalAsynchronous:)
							   withObject:arrayObject 
							waitUntilDone:YES];
		
		// We need to wait for the UIViewController::viewDidAppear method to have been already invoked
		[self waitForSynchronizedDisplayObjects];
		
		[self performSelectorOnMainThread:@selector(onSynchronizeDisplayObjectsInternalAsynchronous:)
							   withObject:arrayObject 
							waitUntilDone:NO];
	}
	
//	else
//	{
//		[self onFulfillDisplayObjectsInternal:aggregate atIndex:index];
//		[self onSynchronizeDisplayObjectsInternal:aggregate atIndex:index];
//	}
}

- (void)onFulfillDisplayObjectsInternalAsynchronous:(id)object
{
	NSArray* arrayObject = (NSArray*)object;
	id aggregate = [arrayObject objectAtIndex:0];
	NSNumber* number = (NSNumber*)[arrayObject objectAtIndex:1];
	NSUInteger index = [number unsignedIntegerValue];
	@try
	{
		[self onFulfillDisplayObjectsInternal:aggregate atIndex:index];
	}
	@finally
	{
		//[arrayObject release];
	}
}

- (void)onSynchronizeDisplayObjectsInternalAsynchronous:(id)object
{
	NSArray* arrayObject = (NSArray*)object;
	id aggregate = [arrayObject objectAtIndex:0];
	NSNumber* number = (NSNumber*)[arrayObject objectAtIndex:1];
	NSUInteger index = [number unsignedIntegerValue];
	@try
	{
		[self onSynchronizeDisplayObjectsInternal:aggregate atIndex:index];
	}
	@finally
	{
		//[arrayObject release];
	}
}

- (BOOL)onFulfillDisplayObjectsInternal:(id)aggregate atIndex:(NSUInteger)index
{
	if (statuses[index] == NO)
		return NO;
	@try
	{
		[aggregate onFulfillDisplayObjects];
		[[SnSApplicationController instance] onLifeCycleEvent:aggregator 
												  onAggregate:(aggregator == aggregate ? nil : aggregate)
													withEvent:SnSInterceptorEventOnFulfillDisplayObjects];
	}
	@catch (NSException* exception)
	{
		SnSLogEW(exception, @"Could not fulfill the display objects");
		[[SnSApplicationController instance] handleException:aggregator 
												   aggregate:(aggregator == aggregate ? nil : aggregate)
												   exception:exception
													  resume:&(statuses[index])];
	}
	return statuses[index];
}

- (BOOL)onSynchronizeDisplayObjectsInternal:(id)aggregate atIndex:(NSUInteger)index
{
	if (statuses[index] == NO)
		return NO;
	if ([aggregate respondsToSelector:@selector(onSynchronizeDisplayObjects)] == YES)
	{
		@try
		{
			[aggregate onSynchronizeDisplayObjects];
			[[SnSApplicationController instance] onLifeCycleEvent:aggregator 
													  onAggregate:(aggregator == aggregate ? nil : aggregate)
														withEvent:SnSInterceptorEventOnSynchronizeDisplayObjects];
			//[[SnSApplicationController instance] renderView:aggregator onAggregate:(aggregator == aggregate ? nil : aggregate)];
		}
		@catch (NSException* exception)
		{
			SnSLogEW(exception, @"Could not synchronize the display objects");
			[[SnSApplicationController instance] handleException:aggregator 
													   aggregate:(aggregator == aggregate ? nil : aggregate)
													   exception:exception 
														  resume:&(statuses[index])];
		}
	}
	return statuses[index];
}

- (void)onDiscardedInternal
{
	id<SnSViewControllerLifeCycle> aggregate = aggregator; 
	//for (id<SnSViewControllerLifeCycle> aggregate in aggregates)
	//{
		@try
		{
			[[SnSApplicationController instance] onLifeCycleEvent:aggregator 
													  onAggregate:(aggregator == aggregate ? nil : aggregate)
														withEvent:SnSInterceptorEventOnDiscarded];
			[aggregate onDiscarded];
		}
		@catch (NSException* exception)
		{
			SnSLogEW(exception, @"An error occured while discarding the object");
			BOOL dummyResume;
			[[SnSApplicationController instance] handleException:aggregator
													   aggregate:(aggregator == aggregate ? nil : aggregate)
													   exception:exception 
														  resume:&(dummyResume)];
		}
	//}
}

@end


#pragma mark - SnSViewControllerDelegate

@implementation SnSViewControllerDelegate

#pragma mark NSObject

- (id)initWithAggregator:(UIViewController<SnSViewControllerAggregator, SnSViewControllerLifeCycle>*)iAggregator
			  aggregates:(NSArray*)iAggregates
{
	if ((self = [super init]))
	{
		aggregator = iAggregator; // do not retain theAggregator or changess are it won't be released (A retains B retains A)
		aggregates = [iAggregates retain];
		
		statuses = malloc(1 * sizeof(BOOL)); //[aggregates count]
		
		NSUInteger index, count = 1; /*[aggregates count]; */
		for (index = 0; index < count; index++)
			statuses[index] = YES;
		
		viewDidAppearCondition = [[NSCondition alloc] init];	
	}
	
	
	return self;
}

- (void)dealloc
{
	[aggregates release];
	[viewDidAppearCondition release];
	
	free(statuses);
	[super dealloc];
}

#pragma mark - UIViewController

- (void)loadView:(UIView*)view
{
	[self onRetrieveDisplayObjectsInternal:view];
}

- (void)viewDidLoad
{
	isFirstCycle = YES;
	NSUInteger index = 0;
	id<SnSViewControllerLifeCycle> aggregate = aggregator;
	//for (id<SnSViewControllerLifeCycle> aggregate in aggregates)
	//{
		if ([self isBusinessObjectsRetrievalAsynchronous:aggregate] == YES)
		{
			// The loading of the business objects should be asynchronous
			[self performSelectorInBackgroundWithAutoreleasePool:@selector(onRetrieveBusinessObjectsInternal:)
													  withObject:[NSNumber numberWithUnsignedInteger:index]];
		}
		else
		{
			NSNumber* number = [NSNumber numberWithUnsignedInteger:index];
			[self onRetrieveBusinessObjectsInternal:number];
		}
		++index;
	//}
}

- (void)viewDidUnload
{
	[self onDiscardedInternal];
}

- (void)viewWillAppear:(BOOL)animated
{
	NSUInteger index = 0;
	id<SnSViewControllerLifeCycle> aggregate = aggregator;
	//for (id<SnSViewControllerLifeCycle> aggregate in aggregates)
	//{
		if ([self isBusinessObjectsRetrievalAsynchronous:aggregate] == NO/* && isFirstCycle == YES*/)
			[self onFulfillDisplayObjectsInternal:aggregate atIndex:index];
		
		++index;
	//}
}

- (void)viewDidAppear:(BOOL)animated
{
	viewDidAppearEntered = YES;
	// We notify that the 'viewDidAppear' method has been entered
	[viewDidAppearCondition signal];
	NSUInteger index = 0;
	id<SnSViewControllerLifeCycle> aggregate = aggregator;
	//for (id<SnSViewControllerLifeCycle> aggregate in aggregates)
	//{
		if ([self isBusinessObjectsRetrievalAsynchronous:aggregate] == NO/* || isFirstCycle == NO*/)
			[self onSynchronizeDisplayObjectsInternal:aggregate atIndex:index];
		++index;
	//}
	isFirstCycle = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
}

- (void)viewDidDisappear:(BOOL)animated
{
}

- (void)waitForSynchronizedDisplayObjects
{
	if (viewDidAppearEntered == NO)
	{
		// We wait for the UIViewController::viewDidAppear method to have been already invoked
		SnSLogD(@"Waiting for the SnSViewController to have appeared");
		[viewDidAppearCondition lock];
		[viewDidAppearCondition wait];
		[viewDidAppearCondition unlock];
	}
}

@end

#pragma mark -
#pragma mark SnSResponserRedirector

@implementation SnSResponserRedirector

- (id)initWith:(id)theTarget
{
	if ((self = [super init]))
		target = theTarget; // do not retain !! or it might cause target to never be released ( A retains B retains A)
	return self;
}

/**
 * Inspired from http://ns.treehouseideas.com/document.page/265 .
 */
- (NSMethodSignature*)methodSignatureForSelector:(SEL)aSelector
{
	if ([target respondsToSelector:aSelector] == YES)
	{
		return [target methodSignatureForSelector:aSelector];
	}
	else
	{
		return [super methodSignatureForSelector:aSelector];
	}
}

- (void)forwardInvocation:(NSInvocation*)anInvocation
{
	SEL selector = [anInvocation selector];
	if ([target respondsToSelector:selector])
	{
		@try
		{
			// After iOS4 upgrade  Objective-C exceptions thrown inside methods invoked via NSInvocation are uncatchable 
			// http://pivotallabs.com/users/amilligan/blog/articles/1302-objective-c-exceptions-thrown-inside-methods-invoked-via-nsinvocation-are-uncatchable
			[anInvocation invokeWithTarget:target];
			//objc_msgSend(target, selector);
		}
		@catch (NSException* exception)
		{
			BOOL resume;
			[[SnSApplicationController instance] handleException:target aggregate:target exception:exception resume:&resume];
		}
	}
	else
	{
		[self doesNotRecognizeSelector:selector];
	}
}

@end

#pragma mark -
#pragma mark SnSWorkItem

@implementation SnSWorkItem

@synthesize container = _container;

#pragma mark NSObject

- (void)dealloc
{
	SnSReleaseAndNil(_container);
    
	[super dealloc];
}

#pragma mark -
#pragma mark SnSWorkItem

- (id)containerForKey:(NSString*)key
{
	@synchronized (self)
	{
		if (_container != nil && [_container isKindOfClass:[NSDictionary class]] == NO)
			[SnSLifeCycleException raise:BAD_USAGE_SNSCODE format:@"Cannot ask a dictionary value on a object"];
		
		return [_container objectForKey:key];
	}
	return nil;
}

- (void)setContainer:(id)object forKey:(NSString*)key;
{
	@synchronized (self)
	{
		if (self.container == nil)
			self.container = [[NSMutableDictionary alloc] init];
		
		else if ([_container isKindOfClass:[NSDictionary class]] == NO)
			[SnSLifeCycleException raise:BAD_USAGE_SNSCODE format:@"Cannot turn the object into a dictionary"];
		
		[_container setObject:object forKey:key];
	}
}

@end
