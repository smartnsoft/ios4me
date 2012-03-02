//
//  SnSCacheItem.h
//  SnSFramework
//
//  Created by Johan Attali on 26/07/11.
//  Copyright 2011 Smart&Soft. All rights reserved.
//

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

+ (id)itemWithKey:(id)iKey
			 data:(NSData*)iData;

/**
 *	Designated Initalizer
 *	Create the Cache Item object with its basic information
 */
- (id)initWithKey:(id)iKey
			 data:(id)iData;


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
