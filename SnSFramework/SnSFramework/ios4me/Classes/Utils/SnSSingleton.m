/* 
 * Copyright (C) 2009 Smart&Soft.
 * All rights reserved.
 *
 * The code hereby is the full property of Smart&Soft, SIREN 517 961 744.
 * http://www.smartnsoft.com - contact@smartnsoft.com
 * 
 * You are not allowed to use the source code or the resulting binary code, nor to modify the source code, without prior permission of the owner.
 *
 * This library is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 */

//
//  SnSSingleton.m
//  SnSFramework
//
//  Created by Johan Attali on 26/07/11.
//  Copyright 2011 Smart&Soft. All rights reserved.
//

#import "SnSSingleton.h"

@implementation SnSSingleton

static id gInstances = nil; 

+ (id) instance
{
	id singleton = nil;
    @synchronized (gInstances)
    {
		if (gInstances == nil)
			gInstances = [[NSMutableDictionary alloc] init];
		
		NSString* aKey = [NSString stringWithFormat:@"%@",[self class]];
		singleton = [gInstances objectForKey:aKey];
        if ( singleton == nil)
		{
            singleton = [[self alloc] init];
            [singleton setup];
			[gInstances setObject:singleton forKey:aKey];
		}
    }
    return singleton;
}

- (void)setup
{
    // do nothing, let the children singleton process their first init there
}

- (void)reset
{
	NSString* aKey = [NSString stringWithFormat:@"%@",[self class]];
	
	@synchronized (gInstances)
	{
		id singleton = [gInstances objectForKey:aKey];
		[singleton release];
		singleton = nil;
		[gInstances removeObjectForKey:aKey];
	}
}

@end
