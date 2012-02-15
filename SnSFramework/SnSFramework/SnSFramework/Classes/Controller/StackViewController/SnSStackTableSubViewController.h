/* 
 * Copyright (C) 2009-2010 Smart&Soft.
 * All rights reserved.
 *
 * The code hereby is the full property of Smart&Soft, SIREN 517 961 744.
 * http://www.smartnsoft.com - contact@smartnsoft.com
 * 
 * You are not allowed to use the source code or the resulting binary code, nor to modify the source code, without prior permission of the owner.
 */

//
//  SnSStackTableSubViewController.h
//  SnSFramework
//
//  Created by «FULLUSERNAME» on «DATE».
//  Copyright «YEAR» «ORGANIZATIONNAME». All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SnSStackTableSubViewController : SnSStackSubViewController <UITableViewDataSource, UITableViewDelegate>
{
	IBOutlet UITableView* _tableView;
}

@property (nonatomic, retain) UITableView* tableView;

@end
