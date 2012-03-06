//
//  SnSLoadingView.m
//  ios4me
//
//  Created by Johan Attali on 06/03/12.
//  Copyright (c) 2012 Smart&Soft. All rights reserved.
//

#import "SnSLoadingView.h"


#import <QuartzCore/QuartzCore.h>

#define VIEW_X(v)			((v).frame.origin.x)
#define VIEW_Y(v)			((v).frame.origin.y)
#define VIEW_WIDTH(v)		((v).frame.size.width)
#define VIEW_HEIGHT(v)		((v).frame.size.height)

@implementation SnSLoadingView

@synthesize images = images_;
@synthesize isAnimating = isAnimating_;
@synthesize hidesWhenStopped = hidesWhenStopped_;
@synthesize animationBlock = animationBlock_;

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if ((self = [super initWithCoder:aDecoder]))
		[self setup];
	
	return self;
}

- (id)initWithFrame:(CGRect)frame
{
	if ((self = [super initWithFrame:frame]))
		[self setup];
	
	return  self;
}

- (void)dealloc
{
	[images_ release];
	
	[super dealloc];
}

- (void)setup
{
	
	// By default: hides when stopped
	self.hidesWhenStopped = YES;
	
	// Remove previous UIView created by the UIAcitivtyIndicatorView
	if ([[self subviews] count] > 0)
		[[[self subviews] objectAtIndex:0] setHidden:YES];
	
}

- (void)startAnimating
{
	isAnimating_ = YES;
	self.hidden = NO;
	
	animationBlock_();
}

- (void)stopAnimating
{
	isAnimating_ = NO;
	if (hidesWhenStopped_)
		self.hidden = YES;
}

- (void)setHidesWhenStopped:(BOOL)hidesWhenStopped
{
	hidesWhenStopped_ = hidesWhenStopped;
	if (!isAnimating_)
		self.hidden = hidesWhenStopped;
}

# pragma mark Custom 

- (void)fadeIn
{
//	if (self.isAnimating)
//	{
//		[UIView animateWithDuration:0.8f
//							  delay:0.0f
//							options:UIViewAnimationOptionAllowUserInteraction
//						 animations:^(void)		{ imgTop.alpha = 1.f; } 
//						 completion:^(BOOL b)	{ if (b) [self fadeOut]; }];
//	}
}

- (void)fadeOut
{
//	if (self.isAnimating)
//	{
//		[UIView animateWithDuration:0.8f
//							  delay:0.0f
//							options:UIViewAnimationOptionAllowUserInteraction 
//						 animations:^(void)		{ imgTop.alpha = 0.f; } 
//						 completion:^(BOOL b)	{ if (b) [self fadeIn]; }];
//	}
}

@end
