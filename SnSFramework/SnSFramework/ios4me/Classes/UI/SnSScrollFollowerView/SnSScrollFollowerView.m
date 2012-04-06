//
//  SnSScrollFollowerView.m
//  ios4me
//
//  Created by Johan Attali on 06/04/12.
//  Copyright (c) 2012 Smart&Soft. All rights reserved.
//

#import "SnSScrollFollowerView.h"

@implementation SnSScrollFollowerView
@synthesize scrollFollowed = scrollFollowed_;

- (id)initWithFrame:(CGRect)frame scrollView:(UIScrollView *)iScrollView
{
    self = [super initWithFrame:frame];
    if (self) {
		self.scrollFollowed = iScrollView;
	}
	
	return self;
}

- (void)dealloc
{
	self.scrollFollowed = nil;
	
	[super dealloc];
}

- (void)follow
{
	// iOS always adds 415 pixels problably used when the view is bouncing
	CGFloat ratio = [self ratio];
	
	// Calculate the indictor length
	CGFloat length = [self indicatorLength];
	
	CGFloat shift = -length*ratio + length*0.5f;
	
	// calculate the new y position
	CGFloat y = ratio * scrollFollowed_.bounds.size.height + shift;
	
	// update the view position
	self.center = CGPointMake(self.center.x, y);
}



#pragma mark -
#pragma mark Scroll Math Calculation
#pragma mark -

-(CGFloat)ratio
{
	return scrollFollowed_.contentOffset.y/(scrollFollowed_.contentSize.height-[self customOverSize]);
}

- (CGFloat)indicatorLength
{
	// Calculate the indicator length
	CGFloat length = scrollFollowed_.bounds.size.height/scrollFollowed_.contentSize.height*scrollFollowed_.bounds.size.height;
	
	// Minimum size is 35px (beware this might change in next version of iOS)
	length = length < 35.f ? 35.f : length;
	
	return length;
}

- (CGFloat)customOverSize
{
	// So far the content size is always incremented by 415px but this can change in future version of iOS
	return 415.f;
}

@end
