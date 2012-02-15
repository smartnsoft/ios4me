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
//  SnSDelegate.h
//  SnSFramework
//
//  Created by Édouard Mercier on 18/12/2009.
//

#import <UIKit/UIKit.h>

#pragma mark -
#pragma mark SnSDelegate

/**
 * Enables to wrap a delegate with a selector.
 */
@interface SnSDelegate : NSObject
{
  id delegate;
  SEL selector;
}

@property(nonatomic, retain, readonly) id delegate;
@property(nonatomic, readonly) SEL selector;

+ (id) delegateWith:(id)theDelegate andSelector:(SEL)theSelector;
- (id) initWith:(id)theDelegate andSelector:(SEL)theSelector;

/**
 * Runs the underlying selector in the current thread. 
 *
 * Warning: this method releases the current object!
 */
- (void) perform;

/**
 * Runs the underlying selector in the current thread.
 *
 * Warning: this method releases the current object!
 *
 * @param object the only argument passed on the selector
 */
- (void) perform:(id)object;

/**
 * Runs the underlying selector in the current thread.
 * 
 * Warning: this method releases the current object!
 *
 * @param object the first argument passed on the selector
 * @param otherObject the second argument passed on the selector
 */
- (void) perform:(id)object andObject:(id)otherObject;

/**
 * Runs the underlying selector in the current thread.
 * 
 * Warning: this method releases the current object!
 *
 * @param object the first argument passed on the selector
 * @param otherObject1 the second argument passed on the selector
 * @param otherObject2 the second argument passed on the selector
 */
- (void) perform:(id)object andObject:(id)otherObject1 andObject:(id)otherObjec2t;

/**
 * Runs the underlying selector in the main thread, and is non-blocking.
 *
 * Warning: this method releases the current object!
 *
 * @param object the only argument passed on the selector
 */
- (void) performOnMainThread:(id)object;

@end

#pragma mark -
#pragma mark SnSDelegateWithObject

/**
 * Enables to wrap a delegate with a selector, like SnSDelegate does, plus it remembers an argument.
 */
@interface SnSDelegateWithObject : SnSDelegate
{
  id object;
}

@property(nonatomic, retain, readonly) id object;

+ (id) delegateWith:(id)theDelegate andSelector:(SEL)theSelector andObject:(id)theObject;
- (id) initWith:(id)theDelegate andSelector:(SEL)theSelector andObject:(id)theObject;

/**
 * Does the same thing as its parent method with the same signature, except that the internal <code>object</code> is used
 * as an object provided in the selector. 
 */
- (void) perform;

@end
