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
//  ___FILENAME___
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright ___YEAR___ ___ORGANIZATIONNAME___. All rights reserved.
//

#import "___FILEBASENAME___.h"

@implementation ___FILEBASENAMEASIDENTIFIER___

#pragma mark -
#pragma mark Singleton Methods
#pragma mark -

/*!
 * @method		
 *  instance
 * @abstract	
 *  Creates a static instance of the DB accessible from everywhere in the application. 
 * @result	
 *  A static instance of the local DB class
 */
+ (id)instance
{
	static ___FILEBASENAMEASIDENTIFIER___* db = nil;
	if (db == nil)
		db = [[[___FILEBASENAMEASIDENTIFIER___ class] alloc] init];
	return db;
}


#pragma mark -
#pragma mark ___FILEBASENAMEASIDENTIFIER___ Specific
#pragma mark -


@end