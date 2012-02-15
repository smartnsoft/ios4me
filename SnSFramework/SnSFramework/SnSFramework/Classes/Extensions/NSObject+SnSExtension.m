/* 
 * Copyright (C) 2009 Smart&Soft.
 * All rights reserved.
 *
 * The code hereby is the full property of Smart&Soft, SIREN 517 961 744.
 * http://www.smartnsoft.com - contact@smartnsoft.com
 * 
 * You are not allowed to use the source code or the resulting binary code, nor to modify the source code, without prior permission of the owner.
 *
 * This library is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 */

//
//  NSObject+SnSExtension.m
//  SnSFramework
//
//  Created by Édouard Mercier on 17/12/2009.
//

#import "NSObject+SnSExtension.h"

#pragma mark -
#pragma mark NSObject(SnSExtensionPrivate)

@interface NSObject(SnSExtensionPrivate)

- (void) selectorInBackgroundWithAutoreleasePool:(id)arg;
- (void) selectorInBackgroundWithAutoreleasePoolWithObject:(id)arg;

@end

@implementation NSObject(SnSExtensionPrivate)

- (void) selectorInBackgroundWithAutoreleasePool:(id)arg
{
  NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
  SnSDelegate * delegate = (SnSDelegate *) arg;
  @try
  {
    [delegate perform];
  }
  @catch (NSException * exception)
  {
    SnSLogEE(exception, @"An unexpected exception has been thrown during the processing!");
  }
  @finally
  {
    // The delegate does not need to be released, since the "perform" method does it!
    [pool drain];
  }
}

- (void) selectorInBackgroundWithAutoreleasePoolWithObject:(id)arg
{
  NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
  NSArray * array = (NSArray *) arg;
  SnSDelegate * delegate = [array objectAtIndex:0];
  @try
  {
    [delegate perform:([array count] == 1 ? nil : [array objectAtIndex:1])];
  }
  @catch (NSException * exception)
  {
    SnSLogEE(exception, @"An unexpected exception has been thrown during the processing!");
  }
  @finally
  {
    // The delegate does not need to be released, since the "perform" method does it!
    [pool drain];
  }
}

@end

#pragma mark -
#pragma mark NSObject(SnSExtension)

@implementation NSObject(SnSExtension)

- (void) performSelectorInBackgroundWithAutoreleasePool:(SEL)aSelector
{
  [self performSelectorInBackground:@selector(selectorInBackgroundWithAutoreleasePool:) 
						 withObject:[SnSDelegate delegateWith:self andSelector:aSelector]];
}

- (void) performSelectorInBackgroundWithAutoreleasePool:(SEL)aSelector withObject:(id)arg
{
  [self performSelectorInBackground:@selector(selectorInBackgroundWithAutoreleasePoolWithObject:) 
						 withObject:[NSArray arrayWithObjects:
									 [SnSDelegate delegateWith:self
												   andSelector:aSelector],
									 arg, nil]];
}

@end