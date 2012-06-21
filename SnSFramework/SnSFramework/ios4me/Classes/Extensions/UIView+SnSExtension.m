//
//  UIView+SnSExtension.m
//  ios4me
//
//  Created by Johan Attali on 29/05/12.
//  Copyright (c) 2012 Smart&Soft. All rights reserved.
//

#import "UIView+SnSExtension.h"

@implementation UIView (SnSExtension)

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

@end
