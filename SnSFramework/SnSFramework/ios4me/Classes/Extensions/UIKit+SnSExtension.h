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
