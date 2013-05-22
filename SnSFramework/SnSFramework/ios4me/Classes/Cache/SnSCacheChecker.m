//
//  SnSCacheChecker.m
//  ios4me
//
//  Created by Johan Attali on 29/02/12.
//  Copyright (c) 2012 Smart&Soft. All rights reserved.
//

#import "SnSCacheChecker.h"
#import "SnSCacheItem.h"
#import "SnSConstants.h"
#import "SnSLog.h"
#import "SnSAbstractCache.h"

@implementation SnSCacheChecker

@synthesize frequency = frequency_;
@synthesize delegate = delegate_;
@synthesize caches = caches_;

#pragma mark -
#pragma mark SnSSingleton
#pragma mark -

- (void)reset
{
	[self stop];
	
	[super reset];
}


#pragma mark -
#pragma mark NSObject
#pragma mark -

- (id)init
{
	if ((self = [super init]))
	{
		caches_		= [[NSMutableArray alloc] initWithCapacity:SnSCacheCheckerMaxCaches];
		frequency_	= SnSCacheCheckerRefreshTime;
		
		[self setup];
	}
	
	return self;
}

- (void)dealloc
{
	SnSReleaseAndNil(caches_);
	
	[super dealloc];
}

#pragma mark -
#pragma mark Process
#pragma mark -

- (void)setup
{	
	// use the system LOW priority queue
	dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0); 
	
	// create our timer source
	timer_ = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
	
	// set the time to fire (we're only going to fire once,
	// so just fill in the initial time).
	dispatch_source_set_timer(timer_,
							  dispatch_walltime(NULL, frequency_ * NSEC_PER_SEC),	// Do not start immediatly wait for frequency time
							  frequency_ * NSEC_PER_SEC,							// Interval
							  (float)(frequency_) * 0.01 * NSEC_PER_SEC				// 1/10th of the frequency for leaveway
							  );
	
	// what to do at each cycle ?
	dispatch_source_set_event_handler(timer_, ^{
		[self process];
	});
	
	// what to do when checks are cancelled ? (eg when the checher is stopped)
	dispatch_source_set_cancel_handler(timer_, ^{
		if ([delegate_ respondsToSelector:@selector(didCancelChecks)])
			[delegate_ didCancelChecks];
	});
	
	// now that our timer is all set to go, start it
	dispatch_resume(timer_);
}

- (void)process
{
	for (SnSAbstractCache* aCache in caches_)
	{
		if ([delegate_ respondsToSelector:@selector(willProcessChecksOnCache:)])
			[delegate_ willProcessChecksOnCache:aCache];
		
		SnSLogD(@"Processing Cache %p", aCache);
		
		NSInteger aTotalLength = 0;
		
		for (id aKey in [aCache.items allKeys])
		{
			SnSCacheItem* aItem = [aCache cachedItemForKey:aKey];
			NSData* aData = aItem.data;
			
			aTotalLength += [aData length];
		}
		
		@synchronized(aCache)
			{ aCache.cacheSize = aTotalLength; }
		
		
		SnSLogD(@"Processing Cache %p - %@ - Purge Needed [%d]", aCache, aCache, aCache.cacheSize > aCache.highCapacity);
		
		// Is purge required
		if (aCache.cacheSize > aCache.highCapacity)
		{
			if ([delegate_ respondsToSelector:@selector(willPurgeCache:)])
				[delegate_ willPurgeCache:aCache];
			
			NSArray* aRemovedKeys = [aCache purge];
			
			if ([delegate_ respondsToSelector:@selector(didPurgeCache:removedKeys:)])
				[delegate_ didPurgeCache:aCache removedKeys:aRemovedKeys];
			
			SnSLogD(@"Purged Cache %p - %@", aCache, aCache, aCache.cacheSize > aCache.highCapacity);
		}

		
		if ([delegate_ respondsToSelector:@selector(didProcessChecksOnCache:)])
			[delegate_ didProcessChecksOnCache:aCache];
	}
}

- (void)stop
{
	// Cancel all events on timer
	dispatch_source_cancel(timer_);
	
	// release the timer
	dispatch_release(timer_);
	
	
}

#pragma mark -
#pragma mark Interact with Caches
#pragma mark -

- (void)addCache:(SnSAbstractCache *)iCache
{
	if (iCache)
	{
		@synchronized(caches_)
			{ [caches_ addObject:iCache]; }
	}
}

#pragma mark -
#pragma mark Accessors
#pragma mark -

- (void)setFrequency:(NSInteger)frequency
{
	frequency_ = frequency;
	
	if (timer_)
	{
		dispatch_source_set_timer(timer_,
								  dispatch_walltime(NULL, frequency_ * NSEC_PER_SEC),	// Do not start immediatly wait for frequency time
								  frequency_ * NSEC_PER_SEC,							// Interval
								  (float)(frequency_) * 0.01 * NSEC_PER_SEC				// 1/10th of the frequency for leaveway
								  );
	}
}

@end
