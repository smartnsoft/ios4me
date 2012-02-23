//
//  SnSMasterCache.h
//  SnSFramework
//
//  Created by Johan Attali on 01/08/11.
//  Copyright 2011 Smart&Soft. All rights reserved.
//

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
