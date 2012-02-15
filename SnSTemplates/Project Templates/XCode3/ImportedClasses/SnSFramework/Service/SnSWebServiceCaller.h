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
//  SnSWebServiceCaller.h
//  SnSFramework
//
//  Created by Édouard Mercier on 23/12/2009.
//

#import <Foundation/Foundation.h>

#pragma mark -
#pragma mark SnSCallException

/**
 * A basis exception that will be used to notify problems during the web service calls.
 */
@interface SnSCallException : NSException

@end

#pragma mark -
#pragma mark SnSWebServiceCaller

/**
 * Enables to define and standardize web service calls.
 */
@interface SnSWebServiceCaller : NSObject

/**
 * Does the same method as its counterpart with 3 arguments, by providing a <code>nil</code> last argument.
 */
- (NSString *) computeUri:(NSString *)methodUriPrefix methodUriSuffix:(NSString *)methodUriSuffix;

/**
 * @param methodUriPrefix the prefix of the URI
 * @param methodUriSuffix the suffix to append to the URI prefix: a "/" will be inserted, if not null nor empty. Can be nul
 * @param andUriParameters a dictionary of <code>NSString *</code> values and keys which indicates the URI parameters
 * @return a computed URI based on the provided URI prefix, suffix and parameters
 */
- (NSString *) computeUri:(NSString *)methodUriPrefix methodUriSuffix:(NSString *)methodUriSuffix uriParameters:(NSDictionary *)uriParameters;

@end
