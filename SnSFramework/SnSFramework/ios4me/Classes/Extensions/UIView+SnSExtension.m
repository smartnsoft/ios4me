//
//  UIView+SnSExtension.m
//  ios4me
//
//  Created by Johan Attali on 29/05/12.
//  Copyright (c) 2012 Smart&Soft. All rights reserved.
//

#import "UIView+SnSExtension.h"

@implementation UIView (SnSExtension)

/**
 * @abstract
 *  Goes through all the subviews and will automitcally call NSLocalizedString with the text set.
 * @discussion
 *  This is very useful when using XIB files because you only have to put the keys inside labels/buttons...
 *  and one call to this selector on the main will localize everything.
 */
- (void)localizeRecursively
{
	for (UIView* v in [self subviews])
	{
		if ([v isKindOfClass:[UILabel class]])
			[(UILabel*)v setText:NSLocalizedString([(UILabel*)v text], nil)];
		
		else if ([v isKindOfClass:[UIButton class]])
		{
			[(UIButton*)v setTitle:NSLocalizedString([(UIButton*)v titleForState:UIControlStateNormal], nil)
						  forState:UIControlStateNormal];
		}
		
		else if ([v isKindOfClass:[UITextField class]])
		{
			
			UITextField* f = (UITextField*)v;
			f.text = NSLocalizedString(f.text, nil);
			f.placeholder = NSLocalizedString(f.placeholder, nil);
		}
		
		[v localizeRecursively];
	}
}

/**
 * @warning
 *  This method is recursive and will add all subviews subviews objects the class
 *  passed in parameter
 */
- (NSArray *)subviewsOfClass:(Class)iClass
{
    NSMutableArray* array = [NSMutableArray arrayWithCapacity:self.subviews.count];
    
    for (UIView* v in self.subviews)
    {
        if ([v isKindOfClass:iClass])
            [array addObject:v];
        
        // recursively add objects from subviews of self
        [array addObjectsFromArray:[v subviewsOfClass:iClass]];
    }
    
    return [NSArray arrayWithArray:array];
}

/**
 * @abstract
 *  This fixes issues with the subviews method on iOS 4.x where some UIViews (suchs as UIScrollViews)
 *  would have by default prebuilt subviews by default
 * @return 
 *  An array of subviews by getting rid of the prebuilt ones
 */
- (NSArray*)subviewsDesired
{
    NSArray* subviews = [self subviews];
    
    // add all other UIViews subclass that have this problem
    // currently: only UIScrollView
    if ([self isKindOfClass:[UIScrollView class]])
    {
        if ([[[UIDevice currentDevice] systemVersion] characterAtIndex:0] < '5')
        {
            NSMutableArray* purged = [NSMutableArray arrayWithCapacity:[[self subviews] count]];
            
            for (UIView* aView in [self subviews])
            {
                if (![aView isKindOfClass:[UIImageView class]] || aView.frame.size.width > 7)
                    [purged addObject:aView];
            }
            
            subviews = [NSArray arrayWithArray:purged];
        }
    }
    
    return subviews;
}

/**
 * @abstract
 *  This signature is missing from UIKit, if you want delay you must have the full thing.
 *  This methods creates a default behaviour for options and set the completion to nil
 */
+ (void)animateWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay animations:(void (^)(void))animations
{
    [UIView animateWithDuration:duration
                          delay:delay
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:animations
                     completion:nil];
}

@end
