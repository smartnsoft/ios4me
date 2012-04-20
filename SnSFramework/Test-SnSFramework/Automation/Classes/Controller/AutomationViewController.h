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
//  Created by Johan Attali on «DATE».
//  Copyright 2012 Smart&Soft. All rights reserved.
//  Created by ApplicationAuthor on ApplicationCreationDate.
//

#import <UIKit/UIKit.h>


#pragma mark -
#pragma mark AutomationViewController
@interface AutomationViewController : SnSTableViewRefreshController <SnsBusinessObjectsRetrievalAsynchronousPolicy>
{
	
}
- (void)pushControllerNamed:(NSString*)iName;

@end
