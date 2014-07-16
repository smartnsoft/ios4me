//
//  SnSCacheItem.m
//  SnSFramework
//
//  Created by Johan Attali on 26/07/11.
//  Copyright 2011 Smart&Soft. All rights reserved.
//

#import "SnSCacheItem.h"
#import "SnSLog.h"

@implementation SnSCacheItem

#pragma mark - Properties

//@synthesize zone = _zone;
@synthesize hits = _hits;
@synthesize key = _key;
@synthesize data = _data;
@synthesize lastAccessedDate = _lastAccessedDate;

#define kSnSCacheItemHitsKey @"hits"
#define kSnSCacheItemKeyKey @"key"
#define kSnSCacheItemDataKey @"data"
#define kSnSCacheItemDateKey @"lastAccessedDate"

#pragma mark - Init Methods

- (void)encodeWithCoder:(NSCoder *)aCoder
{
	SnSLogD(@"Encoding item [%@] ", self);
	[aCoder encodeInteger:_hits forKey:kSnSCacheItemHitsKey];
	[aCoder encodeObject:_key forKey:kSnSCacheItemKeyKey];
	[aCoder encodeObject:_data forKey:kSnSCacheItemDataKey];
	[aCoder encodeObject:_lastAccessedDate forKey:kSnSCacheItemDateKey];
	

}

- (id) initWithCoder:(NSCoder *)aDecoder
{
	if ((self = [super init]))
	{
		_hits				= [aDecoder decodeIntegerForKey:kSnSCacheItemHitsKey];
		_key				= [[aDecoder decodeObjectForKey:kSnSCacheItemKeyKey] retain];
		_data				= [[aDecoder decodeObjectForKey:kSnSCacheItemDataKey] retain];
		_lastAccessedDate	= [[aDecoder decodeObjectForKey:kSnSCacheItemDateKey] retain];
	}
	
	SnSLogD(@"Decoded item [%@] ", self);

	return self;
}

+ (id)itemWithKey:(id)iKey data:(NSData *)iData
{
	SnSCacheItem* aItem = [[[SnSCacheItem alloc] initWithKey:iKey
														data:iData] autorelease];
	
	return aItem;
}

- (id)initWithKey:(id)iKey
			 data:(NSData*)iData;
{
	if ((self = [super init]))
	{
		_key				= [iKey retain];
		_data				= [iData retain];
		
		// Computed default values
		_hits = 0;
		_lastAccessedDate	= [[NSDate date] retain];
		
	}
	return  self;
}

- (void) dealloc
{
	[_key release];
	[_data release];
	[_lastAccessedDate release];
	
	[super dealloc];
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"key: %@ - accessed: %@ - hits: %zd - data: %zdb",
            _key, _lastAccessedDate, _hits, [_data length]];
}

- (BOOL)isEqualToCacheItem:(SnSCacheItem*)iItem
{
	return 
		[_key isEqualToString:iItem.key] &&
		[_data isEqualToData:iItem.data];
}

@end
