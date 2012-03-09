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
