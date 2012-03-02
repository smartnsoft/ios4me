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

#import "SnSSingleton.h"

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
@interface SnSWebServiceCaller : SnSSingleton

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
