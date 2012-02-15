//
//  SnSCacheDelegate.h
//  SnSFramework
//
//  Created by Johan Attali on 29/07/11.
//  Copyright 2011 Smart&Soft. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SnSCacheItem;

@protocol SnSCacheDelegate <NSObject>

@optional

- (SnSCacheItem*)didRetreiveItemForRequest:(NSURLRequest*)iRequest;

- (void)didFailRetreiveItemForRequest:(NSURLRequest*)iRequest
								error:(NSError*)iError;


@end

@protocol SnSCacheConnectionHandler <NSObject>

- (NSData*)handleSynchronousURLConnection:(NSURLRequest*)iRequest returningResponse:(NSURLResponse**)oResponse error:(NSError **)oError;



@end
