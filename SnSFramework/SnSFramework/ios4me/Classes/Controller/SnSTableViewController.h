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

#import "SnSLifeCycle.h"
#import "SnSViewControllerDelegate.h"

#pragma mark -
#pragma mark SnSTableViewControllerBusinessObjects

/**
 * An attempt to formalize the way list of business objects can be handled graphically.
 */
@protocol SnSTableViewControllerBusinessObjects

@optional - (id) retrieveBusinessObjects;
@optional - (id) retrieveIndexObjects;
@optional - (void) synchronizeDisplay:(UITableViewCell *)cell withBusinessObject:(id)businessObject;
/**
 * The method to specify a custom TableCellView for each line of table.
 **/
@optional - (id) initCellWithIdentifier:(NSString *)reuseIdentifier andResponder:(SnSResponserRedirector *)responderRedirector;

@end

#pragma mark -
#pragma mark SnSTableViewController

/**
 * An UITableViewController which follows the SnSViewControllerLifeCycle life-cycle, and which is also able to
 * aggregate other SnSViewControllerLifeCycle entities. 
 */
@interface SnSTableViewController : UITableViewController<SnSViewControllerAggregator, SnSViewControllerLifeCycle, SnSTableViewControllerBusinessObjects>
{
  @private SnSViewControllerDelegate * delegate;
  @protected id businessObjects;
  @protected id indexObjects;
  @private SnSWorkItem * context;
  @private SnSResponserRedirector * responderRedirector;
}

@property(nonatomic, readonly) SnSWorkItem * context;
@property(nonatomic, readonly) SnSResponserRedirector * responderRedirector;

/**
 * The method which is actually called and wrapped when the end-user clicks on a table row.
 */
- (void) tableViewCustom:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

/**
 * The method which is called to override the display style of a table row.
 */
- (void) tableViewCustom:(UITableView *)aTableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;

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
