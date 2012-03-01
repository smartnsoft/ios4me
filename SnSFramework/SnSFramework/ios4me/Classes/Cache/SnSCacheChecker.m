//
//  SnSCacheChecker.m
//  ios4me
//
//  Created by Johan Attali on 29/02/12.
//  Copyright (c) 2012 Smart&Soft. All rights reserved.
//

#import "SnSCacheChecker.h"

@implementation SnSCacheChecker

@synthesize frequency = frequency_;
@synthesize delegate = delegate_;
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
	// create low priority queue
	dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0); 
	
	// create our timer source
	timer_ = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
	
	// set the time to fire (we're only going to fire once,
	// so just fill in the initial time).
	dispatch_source_set_timer(timer_,
							  dispatch_time(DISPATCH_TIME_NOW, 1ull * NSEC_PER_SEC), //frequency_ * NSEC_PER_SEC),
							  DISPATCH_TIME_FOREVER, 1ull * NSEC_PER_SEC); //(float)frequency_*0.01*NSEC_PER_SEC);
	
	// Hey, let's actually do something when the timer fires!
	dispatch_source_set_event_handler(timer_, ^{
		
		[self process];
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
		
		SnSLogD(@"Processing Cache %p \n %@", aCache, aCache);
		
		if ([delegate_ respondsToSelector:@selector(didProcessChecksOnCache:)])
			[delegate_ didProcessChecksOnCache:aCache];
	}
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
								  dispatch_time(DISPATCH_TIME_NOW, frequency_ * NSEC_PER_SEC),
								  DISPATCH_TIME_FOREVER, (float)frequency_*0.01*NSEC_PER_SEC);
	}
}

@end
