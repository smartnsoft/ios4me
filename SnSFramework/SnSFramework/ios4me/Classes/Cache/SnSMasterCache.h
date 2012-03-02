/*
 * (C) Copyright 2009-2011 Smart&Soft SAS (http://www.smartnsoft.com/) and contributors.
 *
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the GNU Lesser General Public License
 * (LGPL) version 3.0 which accompanies this distribution, and is available at
 * http://www.gnu.org/licenses/lgpl.html
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * Lesser General Public License for more details.
 *
 * Contributors:
 *     Smart&Soft - initial API and implementation
 */

#import <Foundation/Foundation.h>
//#import <ASIHTTPRequest/ASICacheDelegate.h>

#import "SnSSingleton.h"

@class SnSCacheItem;
@class SnSCacheSilo;

@interface SnSMasterCache : SnSSingleton <NSCoding/*,ASICacheDelegate*/>
{
    NSMutableDictionary* _caches;
}

/**
 *	Key: a predicate format ex. "*.jpg"
 *	Value: a SnSCacheSilo object
 */
@property (nonatomic, readonly) NSDictionary* caches; 

- (void)addCacheSilo:(SnSCacheSilo*)iCacheSilo predicateString:(NSString *)iStrPredicate;
- (SnSCacheItem*)cachedItemForQuery:(id)iQuery;
- (void)storeCacheItem:(SnSCacheItem*)iItem forQuery:(id)iQuery;
- (SnSCacheSilo*)cacheSiloForQuery:(id)iQuery;

- (void)removeCacheSilo:(SnSCacheSilo*)iCacheSilo;
- (void)removeAllCaches;

- (void)archive;
+ (id)unarchive:(NSString*)iPath;

+ (NSString*)cachesPath;
+ (NSString*)masterCachePath;

@end
