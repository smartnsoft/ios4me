//
//  UILabel+SnSExtension.m
//  ios4me
//
//  Created by Johan Attali on 31/05/12.
//  Copyright (c) 2012 Smart&Soft. All rights reserved.
//

#import "UILabel+SnSExtension.h"

@implementation UILabel (SnSExtension)

- (CGFloat)expectedWidth
{
    CGSize size = [self.text sizeWithFont:self.font
						constrainedToSize:CGSizeMake(FLT_MAX,self.bounds.size.height)
							lineBreakMode:self.lineBreakMode];
	
	return size.width;
}

- (CGFloat)expectedHeight
{
    CGSize size = [self.text sizeWithFont:self.font
						constrainedToSize:CGSizeMake(self.bounds.size.width,FLT_MAX)
							lineBreakMode:self.lineBreakMode];
	
	return size.height;
}

@end
