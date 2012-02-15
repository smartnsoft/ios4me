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

#import "SnSDelegate.h"

#pragma mark -
#pragma mark SnSDelegate

@implementation SnSDelegate

@synthesize delegate;
@synthesize selector;

+ (id) delegateWith:(id)theDelegate andSelector:(SEL)theSelector
{
  return [[SnSDelegate alloc] initWith:theDelegate andSelector:theSelector];
}

#pragma mark -
#pragma mark NSObject

- (id) initWith:(id)theDelegate andSelector:(SEL)theSelector
{
  if (![super init])
  {
    return nil;
  }    
  delegate = theDelegate;
  selector = theSelector;
  return self;
}

- (void) dealloc
{
//  [delegate release];
  [super dealloc];
}

#pragma mark -
#pragma mark SnSDelegate

- (void) perform
{
  //SnSLogD(@"Running the delegate in the calling thread");
  [self.delegate performSelector:self.selector];
  //[self release];
}

- (void) perform:(id)object
{
  //SnSLogD(@"Running the delegate in the calling thread");
  [self.delegate performSelector:self.selector withObject:object];
  //[self release];
}

- (void) perform:(id)object andObject:(id)otherObject
{
  //SnSLogD(@"Running the delegate in the calling thread");
  [self.delegate performSelector:self.selector withObject:object withObject:otherObject];
  //[self release];
}

- (void) perform:(id)object andObject:(id)otherObject1 andObject:(id)otherObject2
{
  //SnSLogD(@"Running the delegate in the calling thread");
  NSMethodSignature * methodSignature = [self.delegate methodSignatureForSelector:self.selector];
  NSInvocation * invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
  invocation.selector = self.selector;
  invocation.target = self.delegate;
  [invocation setArgument:&object atIndex:2];
  [invocation setArgument:&otherObject1 atIndex:3];
  [invocation setArgument:&otherObject2 atIndex:4];
  [invocation invoke];
  //[self release];
}

- (void) performOnMainThread:(id)object
{
  //SnSLogD(@"Running the delegate in the main thread");
  [self.delegate performSelectorOnMainThread:self.selector withObject:object waitUntilDone:YES];
  //[self release];
}

@end

#pragma mark -
#pragma mark SnSDelegateWithObject

@implementation SnSDelegateWithObject

@synthesize object;

+ (id) delegateWith:(id)theDelegate andSelector:(SEL)theSelector andObject:(id)theObject
{
  return [[SnSDelegateWithObject alloc] initWith:theDelegate andSelector:theSelector andObject:theObject];
}

- (id) initWith:(id)theDelegate andSelector:(SEL)theSelector andObject:(id)theObject
{
  if (![super initWith:theDelegate andSelector:theSelector])
  {
    return nil;
  }    
  object = [theObject retain];
  return self;
}

- (void) perform
{
  [super perform:object];
}

@end
