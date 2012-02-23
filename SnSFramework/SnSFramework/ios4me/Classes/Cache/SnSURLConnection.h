//
//  SnSURLConnection.h
//  SnSFramework
//
//  Created by Johan Attali on 01/08/11.
//  Copyright 2011 Smart&Soft. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SnSURLConnectionDelegate <NSObject>

- (void) didFailWithError:(NSError*)oError;

@end

@interface SnSURLConnection : NSObject
{
    NSURLRequest* _request;
	id<SnSCacheDelegate> _delegate;
}
+ (id)connectionWithRequest:(NSURLRequest*)iRequest;
- (id)initWithRequest:(NSURLRequest*)iRequest;

+ (NSData*)retreiveDataForReqest:(NSURLRequest*)iRequest;
- (NSData*)retreiveData;

- (void)process;
- (void)handleResponse:(NSURLResponse*)iResponse data:(NSData*)iData error:(NSError*)iError;

@end
