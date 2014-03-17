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
//  SnSDelegate.m
//  SnSFramework
//
//  Created by Édouard Mercier on 18/12/2009.
//

#import "SnSConstants.h"
#import "SnSDelegate.h"

#pragma mark -
#pragma mark SnSDelegate

@implementation SnSDelegate

@synthesize delegate = _delegate;
@synthesize selector = _selector;

+ (id) delegateWith:(id)theDelegate andSelector:(SEL)theSelector
{
  return [[SnSDelegate alloc] initWith:theDelegate andSelector:theSelector];
}

#pragma mark -
#pragma mark NSObject

- (id)initWith:(id)theDelegate andSelector:(SEL)theSelector
{
  if ((self = [super init]))
  {
      _delegate = theDelegate;
      _selector = theSelector;
  }
    
  return self;
}

- (void) dealloc
{
    _delegate = nil;
    _selector = nil;
    
    [super dealloc];
}

#pragma mark -
#pragma mark SnSDelegate

- (void) perform
{
  [self.delegate performSelector:self.selector];
}

- (void) perform:(id)object
{
  [self.delegate performSelector:self.selector withObject:object];
}

- (void) perform:(id)object andObject:(id)otherObject
{
  [self.delegate performSelector:self.selector withObject:object withObject:otherObject];
}

- (void) performOnMainThread:(id)object
{
    [self.delegate performSelectorOnMainThread:self.selector withObject:object waitUntilDone:YES];
}

- (void) perform:(id)object andObject:(id)otherObject1 andObject:(id)otherObject2
{
  NSMethodSignature * methodSignature = [self.delegate methodSignatureForSelector:self.selector];
  NSInvocation * invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
  invocation.selector = self.selector;
  invocation.target = self.delegate;
  [invocation setArgument:&object atIndex:2];
  [invocation setArgument:&otherObject1 atIndex:3];
  [invocation setArgument:&otherObject2 atIndex:4];
  [invocation invoke];
}

@end

#pragma mark -
#pragma mark SnSDelegateWithObject

@implementation SnSDelegateWithObject

@synthesize object = _object;

+ (id) delegateWith:(id)theDelegate andSelector:(SEL)theSelector andObject:(id)theObject
{
  return [[SnSDelegateWithObject alloc] initWith:theDelegate andSelector:theSelector andObject:theObject];
}

- (id) initWith:(id)theDelegate andSelector:(SEL)theSelector andObject:(id)theObject
{
  if ((self = [super initWith:theDelegate andSelector:theSelector]))
      _object = [theObject retain];

  return self;
}

- (void) perform
{
  [super perform:_object];
}

- (void)dealloc
{
    SnSReleaseAndNil(_object);
    
    [super dealloc];
}

@end
