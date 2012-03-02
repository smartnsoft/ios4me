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

//typedef enum SnSCacheZone
//{
//    SnSCacheZoneMemory = 0,
//    SnSCacheZoneDisk
//}SnSCacheZone;

@interface SnSCacheItem : NSObject <NSCoding>
{
    NSUInteger	_hits;
    id			_key;
    NSData*		_data;
    NSDate*		_lastAccessedDate;
}

/**
 *	Create the Cache Item object with its basic information
 */
- (id)initWithKey:(id)iKey
			 date:(NSDate*)iDate
			 data:(NSData*)iData;

/**
 *	Compare two cache items and return YES if their attributes are identical
 */
- (BOOL)isEqualToCacheItem:(SnSCacheItem*)iItem;


//@property (nonatomic) SnSCacheZone zone;				//!< The where the item is located: ex. Memory, Disk...
@property (nonatomic, readonly) NSUInteger hits;		//!< The number of times the item has been requested
@property (nonatomic,retain) id key;					//!< The key element holding that item (could be a string or url for example)
@property (nonatomic,retain) NSData* data;				//!< The data associated with that element
@property (nonatomic,retain) NSDate* lastAccessedDate;	//!< The last time the element was accessed


@end
