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
//  ￼___FILENAME___
//  ___PROJECTNAMEASIDENTIFIER___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright ___YEAR___ ___ORGANIZATIONNAME___. All rights reserved.
//

#import "___FILEBASENAME___.h"

@implementation ___FILEBASENAME___
@synthesize mainID = mainID_;

#pragma mark -
#pragma mark Init/Dealloc
#pragma mark -

- (id)initWithJSONDictionary:(NSDictionary *)iDic
{
	if ((self = [super init]))
	{
		mainID_ = [[NSString alloc] initWithDictionary:iDic key:kAbstractObjectIDKey];
	}
	
	return self;
}

- (void)dealloc
{
	self.mainID = nil;
	
	[super dealloc];
}

@end