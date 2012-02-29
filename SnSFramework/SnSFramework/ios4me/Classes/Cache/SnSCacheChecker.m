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

#pragma mark -
#pragma mark NSObject
#pragma mark -

- (id)init
{
	if ((self = [super init]))
	{
		caches_		= [[NSMutableArray alloc] initWithCapacity:SnSCacheCheckerMaxCaches];
		frequency_	= SnSCacheCheckerRefreshTime;
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
	dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0); 
	
	// create our timer source
	dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
	
	// set the time to fire (we're only going to fire once,
	// so just fill in the initial time).
	dispatch_source_set_timer(timer,
							  dispatch_time(DISPATCH_TIME_NOW, frequency_ * NSEC_PER_SEC),
							  DISPATCH_TIME_FOREVER, (float)frequency_*0.01*NSEC_PER_SEC);
	
	// Hey, let's actually do something when the timer fires!
	dispatch_source_set_event_handler(timer, ^{
		
		[self process];
	});
	
	// now that our timer is all set to go, start it
	dispatch_resume(timer);
}

- (void)process
{
//	dispatch_queue_t t = dispatch_queue_create(<#const char *label#>, <#dispatch_queue_attr_t attr#>)
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

@end
