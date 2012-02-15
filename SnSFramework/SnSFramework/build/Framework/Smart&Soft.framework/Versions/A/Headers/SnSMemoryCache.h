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
//  SnSMemoryCache.h
//  SnSFramework
//
//  Created by Édouard Mercier on 10/24/2009.
//

#import <Foundation/Foundation.h>

#import "SnSSingleton.h"

/**
 *	The memory cache holds data up to a certain limit in memory.
 *	That amount is set in the cache silo creation.
 */
@interface SnSMemoryCache : SnSSingleton
{
	NSMutableDictionary * _items;
}

@end
