/*
 * (C) Copyright 2009-2011 Smart&Soft SAS (http://www.smartnsoft.com/) and contributors.
 *
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the GNU Lesser General Public License
 * (LGPL) version 3.0 which accompanies this distribution, and is available at
 * http://www.gnu.org/licenses/lgpl.html
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * Lesser General Public License for more details.
 *
 * Contributors:
 *     Smart&Soft - initial API and implementation
 */

#import <UIKit/UIKit.h>

#pragma mark -
#pragma mark SnSDelegate

/**
 * Enables to wrap a delegate with a selector.
 */
@interface SnSDelegate : NSObject
{
  id _delegate;
  SEL _selector;
}

@property(nonatomic, assign, readonly) id delegate; // do not retain the delegate or it won't be released
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
  id _object;
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
