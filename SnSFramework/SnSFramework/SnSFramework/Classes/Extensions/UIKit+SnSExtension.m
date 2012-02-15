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
//  UIKit+SnSExtension.m
//  SnSFramework
//
//  Created by Édouard Mercier on 18/05/2010.
//

#import "UIKit+SnSExtension.h"

#pragma mark -
#pragma mark UINavigationController(SnSExtension)

@implementation UINavigationController(SnSExtension)

- (void) popAndPushViewController:(UIViewController *)viewController
{
  /*
	NSMutableArray * controllers = [NSMutableArray arrayWithCapacity:[self.viewControllers count]];
  NSRange range;
  range.location = 0;
  range.length = [self.viewControllers count] - 1;
  [controllers addObjectsFromArray:[self.viewControllers subarrayWithRange:range]];
  [controllers addObject:viewController];
  // Caution: do not use the animation, otherwise the UINavigationControler gets lost!
	[self setViewControllers:controllers animated:NO];
	 */
	if ([self.viewControllers count] > 1) 
	{
		[self popViewControllerAnimated:NO];
		[self pushViewController:viewController animated:NO];
	}
	else 
	{
		[self setViewControllers:[NSArray arrayWithObjects:viewController,nil] animated:NO];
	}

}

- (void) popViewControllers:(NSUInteger)howMany animated:(BOOL)animated
{
  NSRange range;
  range.location = 0;
  range.length = [self.viewControllers count] - howMany;
  // Caution: do not use the animation, otherwise the UINavigationControler gets lost!
  [self setViewControllers:[self.viewControllers subarrayWithRange:range] animated:animated];
}

@end
