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
//  SnSViewController.h
//  SnSFramework
//
//  Created by Édouard Mercier on 18/12/2009.
//

#import <UIKit/UIKit.h>

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

- (id) initWith:(UIViewController<SnSViewControllerAggregator, SnSViewControllerLifeCycle> *)theAggregator aggregates:(NSArray *)theAggregates;

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
  @private id container;
}

- (id) getObject;
- (id) getObject:(NSString *)key;
- (void) setObject:(id)object;
- (void) setObject:(id)object forKey:(NSString *)key;

@end

#pragma mark -
#pragma mark SnSViewController

/**
 * An UIViewController which follows the SnSViewControllerLifeCycle life-cycle, and which is also able to
 * aggregate other SnSViewControllerLifeCycle entities. 
 */
@interface SnSViewController : UIViewController<SnSViewControllerAggregator, SnSViewControllerLifeCycle>
{
  @private SnSViewControllerDelegate * delegate;
  @private SnSWorkItem * businessObject;
  @private SnSWorkItem * context;
  @private SnSResponserRedirector * responderRedirector;
}

@property(nonatomic, retain, readonly) SnSWorkItem * businessObject;
@property(nonatomic, retain, readonly) SnSWorkItem * context;
@property(nonatomic, retain, readonly) SnSResponserRedirector * responderRedirector;

/**
 * That method will hang the calling thread until the UIViewController::viewDidAppear:(BOOL) has been entered.
 *
 * <p>Should never be invoked from the GUI thread, otherwise a dead-lock may occur!</p>
 */
- (void) waitForSynchronizedDisplayObjects;

/**
 * Use that method in order to synchronize the display.
 *
 * <p>The method will invoke the SnSViewControllerLifeCycle::onSynchronizeDisplayObjects protocol method.</p>
 */
- (void) synchronizeDisplayObjects;

/**
 * Use that method in order to reload the data and synchronize the display accordingly.
 *
 * <p>The method will invoke the SnSViewControllerLifeCycle::onRetrieveBusinessObjects and SnSViewControllerLifeCycle::onSynchronizeDisplayObjects protocol methods.</p>
 */
- (void) retrieveBusinessObjectsAndSynchronize;

@end
