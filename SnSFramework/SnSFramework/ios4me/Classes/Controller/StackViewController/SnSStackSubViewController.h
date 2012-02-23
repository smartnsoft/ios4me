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
//  SnSStackSubViewController.h
//  SnSFramework
//
//  Created by «FULLUSERNAME» on «DATE».
//  Copyright «YEAR» «ORGANIZATIONNAME». All rights reserved.
//

#import <UIKit/UIKit.h>

@class SnSStackSubView;
@class SnSStackViewController;

@interface SnSStackSubViewController : SnSViewController 
{
	CGRect	_framePortrait;
	CGRect	_frameLandscape;
	
//	SnSStackSubView* _stackSubView;
	
	SnSStackViewController* _stackController;
	
	
	BOOL _isShifted;
}

@property (nonatomic, assign) CGRect framePortrait;
@property (nonatomic, assign) CGRect frameLandscape;
@property (nonatomic, assign) SnSStackViewController* stackController;

#pragma mark UIView

- (SnSStackSubView*)stackview;


@end
