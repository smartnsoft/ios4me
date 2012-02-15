/* 
 * Copyright (C) 2009 Smart&Soft.
 * All rights reserved.
 *
 * The code hereby is the full property of Smart&Soft, SIREN 517 961 744.
 * http://www.smartnsoft.com - contact@smartnsoft.com
 * 
 * You are not allowed to use the source code or the resulting binary code, nor to modify the source code, without prior permission of the owner.
 */

//
//  SnSLifeCycle.m
//  SnSFramework
//
//  Created by Édouard Mercier on 19/12/2009.
//

#import "SnSLifeCycle.h"

#pragma mark -
#pragma mark SnSAggregateViewController

@implementation SnSAggregateViewController

- (void) onRetrieveDisplayObjects:(UIView *)view
{
}

- (void) onRetrieveBusinessObjects
{
}

- (void) onFulfillDisplayObjects
{
}

- (void) onDiscarded
{
}

@end

#pragma mark -
#pragma mark SnSLifeCycleException

NSString * const BAD_USAGE_SNSCODE = @"Bad usage";

@implementation SnSLifeCycleException

+ (void) raise:(NSString *)name format:(NSString *)format, ...
{
	va_list arguments;
	va_start(arguments, format);
  @try
  {
    @throw [[SnSLifeCycleException alloc] initWithName:name reason:[[NSString alloc] initWithFormat:format arguments:arguments] userInfo:nil];
  }
  @finally
  {
    va_end(arguments);
  }
}

@end

#pragma mark -
#pragma mark SnSBusinessException

@implementation SnSBusinessObjectException
@end
