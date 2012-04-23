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
//  NSObject+SnSExtension.h
//  SnSFramework
//
//  Created by Édouard Mercier on 17/12/2009.
//

#import <Foundation/Foundation.h>

/**
 * Defined in order to augment the native NSObject class.
 *
 * <p>
 * Because the framework extends a class via a category, the project which uses the resulting library must use the <code>-ObjC</code> and <code>-all_load</code> linking option,
 * as explained at http://developer.apple.com/mac/library/qa/qa2006/qa1490.html and http://www.dribin.org/dave/blog/archives/2006/03/13/static_objc_lib/
 * and http://www.duanefields.com/2008/08/25/objective-c-static-libraries-and-categories/.
 * </p>
 */
@interface NSObject(SnSExtension)

/**
 * Does the same thing as the built-in <code>- (void) performSelectorInBackground:(SEL)aSelector</code>,
 * but creates an NSAutoreleasePool at the start of the thread, and drains it at the end of its life cycle.
 */
- (void) performSelectorInBackgroundWithAutoreleasePool:(SEL)aSelector;

/**
 * Does the same thing as the built-in <code>- (void) performSelectorInBackground:(SEL)aSelector withObject:(id)arg</code>,
 * but creates an NSAutoreleasePool at the start of the thread, and drains it at the end of its life cycle.
 */
- (void) performSelectorInBackgroundWithAutoreleasePool:(SEL)aSelector withObject:(id)arg;

@end
