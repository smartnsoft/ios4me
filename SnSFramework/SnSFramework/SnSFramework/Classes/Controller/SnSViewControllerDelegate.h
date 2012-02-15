//
//  SnSMasterViewController.h
//  SnSFramework
//
//  Created by Johan Attali on 09/09/11.
//  Copyright 2011 Smart&Soft. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SnSLifeCycle.h"

#pragma mark -
#pragma mark SnSViewControllerAggregator

/**
 * Indicates that the current object is able to aggregate SnSViewControllerLifeCycle entities.
 */
@protocol SnSViewControllerAggregator

/**
 * @return an array of SnSViewControllerLifeCycle objects, which indicates the entities that are handled by the current object
 */
- (NSArray *) onRetrieveAggregates;

@end

#pragma mark -
#pragma mark SnSViewControllerDelegate

/**
 * An internal class which enables to bind a UIViewController, or derivated class to a list of SnSViewControllerLifeCycle entities.
 */
@interface SnSViewControllerDelegate : NSObject
{
	/**
	 * The entity which holds all the aggregates.
	 *
	 * This attribute will not be released when the object is released! 
	 */
@private UIViewController<SnSViewControllerAggregator, SnSViewControllerLifeCycle> * aggregator;
@private BOOL isFirstCycle;
@private NSArray * aggregates;
@private BOOL * statuses;
	
	/**
	 * Defined in order to indicate whether the UIViewController::viewDidAppear method has already been invoked.
	 */
@private BOOL viewDidAppearEntered;
	
	/**
	 * Defined in order to notify when the UIViewController::viewDidAppear method is being been entered.
	 */
@private NSCondition * viewDidAppearCondition;
}

- (id) initWithAggregator:(UIViewController<SnSViewControllerAggregator, SnSViewControllerLifeCycle> *)theAggregator
			   aggregates:(NSArray *)theAggregates;

- (void) loadView:(UIView *)view;
- (void) viewDidLoad;
- (void) viewDidUnload;
- (void) viewWillAppear:(BOOL)animated;
- (void) viewDidAppear:(BOOL)animated;
- (void) viewWillDisappear:(BOOL)animated;
- (void) viewDidDisappear:(BOOL)animated;

- (void) waitForSynchronizedDisplayObjects;

@end

#pragma mark -
#pragma mark SnSResponserRedirector

/**
 * Wraps some responder calls, so that potential exception be handled.
 *
 * Especially useful when setting the target and selection of a UIResponder object.
 */
@interface SnSResponserRedirector : NSObject
{
	@private id target;
}

- (id) initWith:(id)theTarget;

@end

#pragma mark -
#pragma mark SnSWorkItem

/**
 * Enables to store and access objects. 
 */
@interface SnSWorkItem : NSObject
{
	id _container;
}

@property (retain) id container;

- (id)containerForKey:(NSString *)key;
- (void)setContainer:(id)object forKey:(NSString *)key;

@end

