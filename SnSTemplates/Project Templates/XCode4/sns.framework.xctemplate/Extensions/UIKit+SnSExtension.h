/* 
 * Copyright (C) 2009-2010 Smart&Soft.
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
//  UIKit+SnSExtension.h
//  SnSFramework
//
//  Created by Édouard Mercier on 18/05/2010.
//

#import <Foundation/Foundation.h>

/**
 * Defined in order to augment the native UINavigationController class.
 *
 * <p>
 * Because the framework extends a class via a category, the project which uses the resulting library must use the <code>-ObjC</code> and <code>-all_load</code> linking option,
 * as explained at http://developer.apple.com/mac/library/qa/qa2006/qa1490.html and http://www.dribin.org/dave/blog/archives/2006/03/13/static_objc_lib/
 * and http://www.duanefields.com/2008/08/25/objective-c-static-libraries-and-categories/.
 * </p>
 */
@interface UINavigationController(SnSExtension)

/**
 * Pops the current view controller and replace it with the given one.
 */
- (void) popAndPushViewController:(UIViewController *)viewController;

/**
 * Pops several view controllers at the same time.
 *
 * @param howMany the number of UIViewControllers to pop
 * @param animated the traditional animation flag
 */
- (void) popViewControllers:(NSUInteger)howMany animated:(BOOL)animated;

@end
