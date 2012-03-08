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
//  ImageRetrievalViewController.h
//  Test-SnSFramework
//
//  Created by «FULLUSERNAME» on «DATE».
//  Copyright «YEAR» «ORGANIZATIONNAME». All rights reserved.
//

#import <UIKit/UIKit.h>

#import <ios4me/SnSTableViewRefreshController.h>

@interface ImageRetrievalViewController : SnSViewController  <UITableViewDataSource,UITableViewDelegate>
{
	NSArray* businessObjects_;
}

@property (nonatomic, retain) NSArray* businessObjects;

@end
