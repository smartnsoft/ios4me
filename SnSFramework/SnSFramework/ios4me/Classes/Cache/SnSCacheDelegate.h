//
//  SnSCacheDelegate.h
//  SnSFramework
//
//  Created by Johan Attali on 29/07/11.
//  Copyright 2011 Smart&Soft. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SnSCacheItem;
@class SnSAbstractCache;

@protocol SnSCacheDelegate <NSObject>

@optional

- (SnSCacheItem*)didRetreiveItemForRequest:(NSURLRequest*)iRequest;

- (void)didFailRetreiveItemForRequest:(NSURLRequest*)iRequest
								error:(NSError*)iError;


@end

@protocol SnSCacheCheckerDelegate <NSObject>

@optional

#pragma mark Checks

- (void)willProcessChecksOnCache:(SnSAbstractCache*)iCache;
- (void)didProcessChecksOnCache:(SnSAbstractCache*)iCache;

#pragma mark Purge

- (void)willPurgeCache:(SnSAbstractCache*)iCache;
- (void)didPurgeCache:(SnSAbstractCache*)iCache removedKeys:(NSArray*)iKeys;

- (void)didCancelChecks;



@end
