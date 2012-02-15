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

/**
 * Proposes a simple memory cache.
 *
 * Not used for the moment...
 */
@interface SnSMemoryCache : NSObject
{
  NSMutableDictionary * dictionary;
}

+ (SnSMemoryCache *) instance;
- (id) getObject:(NSString *)key;
- (void) setObject:(id)object forKey:(NSString *)key;

@end
