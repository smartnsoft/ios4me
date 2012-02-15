//
//  ___PROJECTNAMEASIDENTIFIER___Utils.m
//  ___PROJECTNAMEASIDENTIFIER___
//
//  Created by «FULLUSERNAME» on «DATE».
//  Copyright «YEAR» «ORGANIZATIONNAME». All rights reserved.
//  Created by ApplicationAuthor on ApplicationCreationDate.
//

#import "___PROJECTNAMEASIDENTIFIER___Utils.h"


@implementation ___PROJECTNAMEASIDENTIFIER___Utils

+ (UIButton *) initButton:(CGRect)frame withTarget:(id)target withAction:(SEL)sel withImage:(UIImage *)imgBackground withImagePressed:(UIImage *)imgBackgroundPressed fusionImage:(BOOL)fusion
{
	UIButton * button = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	button.frame = frame;
	button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	[button addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
	
	[button setBackgroundImage:[SnSImageUtils centerImage:imgBackground inFrame:frame] forState:UIControlStateNormal];
	
  if (imgBackgroundPressed != nil) 
  {
    if (fusion == YES) {
      [button setBackgroundImage:[SnSImageUtils addImage:imgBackground andOtherImage:imgBackgroundPressed] forState:UIControlStateHighlighted];
    }
    else 
    {
      [button setBackgroundImage:imgBackgroundPressed forState:UIControlStateHighlighted];
    }
	}
	
	return button;
}

@end
