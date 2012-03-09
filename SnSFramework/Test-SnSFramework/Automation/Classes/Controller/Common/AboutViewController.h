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
//  AutomationViewController.m
//  Automation
//
//  Created by «FULLUSERNAME» on «DATE».
//  Copyright «YEAR» «ORGANIZATIONNAME». All rights reserved.
//  Created by ApplicationAuthor on ApplicationCreationDate.
//

#import <UIKit/UIKit.h>

#pragma mark -
#pragma mark AboutViewController
@interface AboutViewController : SnSViewController <UIWebViewDelegate>
{
	// Data
	NSString * content;
  
	// to display received image
	// UI
  UIActivityIndicatorView * activity;
  NSURL *baseURL;
  UIWebView * aboutContent;
}

@property (nonatomic, retain) NSString * content;

@property (nonatomic, retain) UIActivityIndicatorView * activity;
@property (nonatomic, retain) UIWebView * aboutContent;

@end
