/* 
 * Copyright (C) 2009-2011 Smart&Soft.
 * All rights reserved.
 *
 * The code hereby is the full property of Smart&Soft, SIREN 517 961 744.
 * http://www.smartnsoft.com - contact@smartnsoft.com
 * 
 * You are not allowed to use the source code or the resulting binary code, nor to modify the source code, without prior permission of the owner.
 */

//
//  Test-TableView.h
//  Test-SnSFramework
//
//  Created by Johan Attali on 31/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

// For iOS
#import <GHUnitIOS/GHUnit.h> 
// For Mac OS X
//#import <GHUnit/GHUnit.h>

#import "TableViewController.h"

@interface TestTableView : GHAsyncTestCase <TableViewControllerDelegate>
{
	TableViewController* _tableController;
}

- (void)performTouchInView:(UIView *)view;

@end
