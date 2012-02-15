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
#import "SnSViewControllerDelegate.h"

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

/**
 * Call this method whenever you need to refresh UI elements with a specfic orientation
 * @param iOrientation The interface orientation taht will be used to update the layout
 */
- (void) updateDisplayForOrientation:(UIInterfaceOrientation)iOrientation;


@end
