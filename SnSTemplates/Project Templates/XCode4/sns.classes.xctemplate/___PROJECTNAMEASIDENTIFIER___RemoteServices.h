//
//  ￼___FILENAME___
//  ___PROJECTNAMEASIDENTIFIER___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright ___YEAR___ ___ORGANIZATIONNAME___. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ___PROJECTNAMEASIDENTIFIER___AbstractObject;

typedef void (^___PROJECTNAMEASIDENTIFIER___ServicesBlock)(id);


@interface ___PROJECTNAMEASIDENTIFIER___RemoteServices : SnSRemoteServices

#pragma mark Parsing

- (NSObject *)dictionaryResponseFromRequest:(ASIHTTPRequest *)iRequest;
- (NSObject *)dictionaryResponseFromResponse:(NSString*)iResponse;

- (id)contentFromJSONObject:(id)iJSON withClass:(Class)iClass;

#pragma mark Working on Requests

- (ASIHTTPRequest*)defaultRequestFromURL:(NSURL*)iURL;
- (void)processRequest:(ASIHTTPRequest*)iRequest completionBlock:(___PROJECTNAMEASIDENTIFIER___ServicesBlock)iBlock forClass:(Class)iClass;
- (void)processTestFile:(NSString*)iFileName completionBlock:(___PROJECTNAMEASIDENTIFIER___ServicesBlock)iBlock forClass:(Class)iClass;

@end
