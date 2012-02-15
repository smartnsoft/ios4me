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
//  TableViewController.h
//  Test-SnSFramework
//
//  Created by «FULLUSERNAME» on «DATE».
//  Copyright «YEAR» «ORGANIZATIONNAME». All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TableViewControllerDelegate <NSObject>

@optional
- (void)didCompleteRetreiveBusinessObjects;
- (void)didCompleteSelectRow;

@end

@interface TableViewController : SnSTableViewController
{
	id<TableViewControllerDelegate> _delegate;
	UIButton* _testButton;
}

@property (nonatomic,assign) id<TableViewControllerDelegate> delegate;
@property (nonatomic,retain) UIButton* testButton;

- (id)businessObjects;
- (void)clickedTest:(id)sender;

@end
