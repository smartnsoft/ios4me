//
//  SnSCacheChecker.h
//  ios4me
//
//  Created by Johan Attali on 29/02/12.
//  Copyright (c) 2012 Smart&Soft. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SnSSingleton.h"
#import "SnSCacheDelegate.h"

@class SnSAbstractCache;

@interface SnSCacheChecker : SnSSingleton
{
	NSMutableArray* caches_;	//<! The list of caches to check (basically all SnSAbstractCaches instances)
	NSInteger	frequency_;		//<! The number of seconds between each cache checker cycle
	
	id <SnSCacheCheckerDelegate> delegate_; //<! The cache checker delegate
	
	@protected
	dispatch_source_t timer_;

}

@property (nonatomic, assign) NSInteger frequency;						//<! The number of seconds between each cache checker cycle
@property (nonatomic, assign) id <SnSCacheCheckerDelegate> delegate; 	//<! The cache checker delegate

#pragma mark Process

- (void)setup;
- (void)process;
- (void)stop;

#pragma mark Interact with Caches

- (void)addCache:(SnSAbstractCache*)iCache;

@end
