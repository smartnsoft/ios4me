//
//  EGORefreshTableHeaderView.m
//
//  Created by Devin Doty on 10/14/09October14.
//  Copyright 2009 enormego. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "EGORefreshTableHeaderView.h"
#import "SnSConstants.h"
#import "SnSUtils.h"

#define TEXT_COLOR		[UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
#define IMAGE_NAME		@"blueArrow"
#define STATUS_LOADING	NSLocalizedString(@"Loading...", @"Loading Status")
#define STATUS_PULL		NSLocalizedString(@"Pull down to refresh...", @"Pull down to refresh status")
#define STATUS_RELEASE	NSLocalizedString(@"Release to refresh...", @"Release to refresh status")
#define STATUS_UPDATED	NSLocalizedString(@"Last Updated ", @"Release to refresh status")

#define FLIP_ANIMATION_DURATION 0.18f


@interface EGORefreshTableHeaderView (Private)
- (void)setState:(EGOPullRefreshState)aState;
@end

@implementation EGORefreshTableHeaderView

@synthesize delegate=_delegate;
@synthesize imgName = _imgName;
@synthesize textColor = _textColor;

@synthesize statusPullStr = _statusPullStr;
@synthesize statusLoadingStr = _statusLoadingStr;
@synthesize statusReleaseStr = _statusReleaseStr;
@synthesize statusUpdatedStr = _statusUpdatedStr;

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if ((self = [super initWithCoder:aDecoder]))
		[self setupWithTextColor:TEXT_COLOR imageNamed:IMAGE_NAME];
	
	return  self;
}


- (id)initWithFrame:(CGRect)frame arrowImageName:(NSString *)arrow textColor:(UIColor *)textColor
{
    if((self = [super initWithFrame:frame])) 
		[self setupWithTextColor:textColor imageNamed:arrow];
	
    return self;
	
}

- (id)initWithFrame:(CGRect)frame  
{
  return [self initWithFrame:frame arrowImageName:IMAGE_NAME textColor:TEXT_COLOR];
}

- (void)setupWithTextColor:(UIColor*)textColor imageNamed:(NSString*)imgName;
{
	self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	self.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];


	[[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
	[[[self layer] sublayers] makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
	
	
	CGRect frame = self.frame;
	
	textColor = textColor == nil ? TEXT_COLOR : textColor;
	imgName   = imgName   == nil ? IMAGE_NAME : imgName;
	
	_statusPullStr		= _statusPullStr    == nil ? [STATUS_PULL retain]    : _statusPullStr;
	_statusLoadingStr	= _statusLoadingStr == nil ? [STATUS_LOADING retain] : _statusLoadingStr;
	_statusReleaseStr	= _statusReleaseStr == nil ? [STATUS_RELEASE retain] : _statusReleaseStr;
	_statusUpdatedStr	= _statusUpdatedStr == nil ? [STATUS_UPDATED retain] : _statusUpdatedStr;

	SnSReleaseAndNil(_textColor);
	SnSReleaseAndNil(_imgName);
	_textColor	= [textColor retain];
	_imgName	= [imgName retain];
	
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 30.0f, self.frame.size.width, 20.0f)];
	label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	label.font = [UIFont systemFontOfSize:12.0f];
	label.textColor = textColor;
	label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
	label.shadowOffset = CGSizeMake(0.0f, 1.0f);
	label.backgroundColor = [UIColor clearColor];
	label.textAlignment = UITextAlignmentCenter;
	[self addSubview:label];
	_lastUpdatedLabel=label;
	[label release];
	
	label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 48.0f, self.frame.size.width, 20.0f)];
	label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	label.font = [UIFont boldSystemFontOfSize:13.0f];
	label.textColor = textColor;
	label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
	label.shadowOffset = CGSizeMake(0.0f, 1.0f);
	label.backgroundColor = [UIColor clearColor];
	label.textAlignment = UITextAlignmentCenter;
	[self addSubview:label];
	_statusLabel=label;
	[label release];
	
	CALayer *layer = [CALayer layer];
	layer.frame = CGRectMake(25.0f, frame.size.height - 50.0f, 30.0f, 45.0f);
	layer.contentsGravity = kCAGravityResizeAspect;
	layer.contents = (id)[SnSImageUtils imageNamed:imgName].CGImage;
	
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
	if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
		layer.contentsScale = [[UIScreen mainScreen] scale];
	}
#endif
	
	[[self layer] addSublayer:layer];
	_arrowImage=layer;
	
	UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	view.frame = CGRectMake(25.0f, frame.size.height - 38.0f, 20.0f, 20.0f);
	[self addSubview:view];
	_activityView = view;
	[view release];
	
	
	[self setState:EGOOPullRefreshNormal];

}

-(void)setFrame:(CGRect)frame
{
	[super setFrame:frame];
	
	[self setupWithTextColor:_textColor imageNamed:_imgName];
}

#pragma mark -
#pragma mark Setters

- (void)refreshLastUpdatedDate {
	
	if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceLastUpdated:)]) {
		
		NSDate *date = [_delegate egoRefreshTableHeaderDataSourceLastUpdated:self];
		
		[NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehaviorDefault];
		NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
		[dateFormatter setLocale:[NSLocale currentLocale]];
		[dateFormatter setDateStyle:NSDateFormatterShortStyle];
		[dateFormatter setTimeStyle:NSDateFormatterShortStyle];

		_lastUpdatedLabel.text = [NSString stringWithFormat:@"%@: %@", _statusUpdatedStr, [dateFormatter stringFromDate:date]];
		[[NSUserDefaults standardUserDefaults] setObject:_lastUpdatedLabel.text forKey:@"EGORefreshTableView_LastRefresh"];
		[[NSUserDefaults standardUserDefaults] synchronize];
		
	} else {
		
		_lastUpdatedLabel.text = nil;
		
	}

}

- (void)setState:(EGOPullRefreshState)aState{
	
	switch (aState) {
		case EGOOPullRefreshPulling:
			
			_statusLabel.text = _statusReleaseStr;
			[CATransaction begin];
			[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
			_arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
			[CATransaction commit];
			
			break;
		case EGOOPullRefreshNormal:
			
			if (_state == EGOOPullRefreshPulling) {
				[CATransaction begin];
				[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
				_arrowImage.transform = CATransform3DIdentity;
				[CATransaction commit];
			}
			
			_statusLabel.text = _statusPullStr;
			[_activityView stopAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			_arrowImage.hidden = NO;
			_arrowImage.transform = CATransform3DIdentity;
			[CATransaction commit];
			
			[self refreshLastUpdatedDate];
			
			break;
		case EGOOPullRefreshLoading:
			
			_statusLabel.text = _statusLoadingStr;
			[_activityView startAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			_arrowImage.hidden = YES;
			[CATransaction commit];
			
			break;
		default:
			break;
	}
	
	_state = aState;
}

- (void)setTextColor:(UIColor *)textColor
{
	SnSReleaseAndNil(_textColor);
	
	_textColor = [textColor retain];
	_lastUpdatedLabel.textColor = _textColor;
	_statusLabel.textColor = _textColor;
}

- (void)setImgName:(NSString *)imgName
{
	SnSReleaseAndNil(_imgName);
	
	_imgName = [imgName retain];
	
	[self setupWithTextColor:_textColor imageNamed:imgName];
}


#pragma mark -
#pragma mark ScrollView Methods

- (void)egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView {	
	
	if (_state == EGOOPullRefreshLoading) {
		
		CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
		offset = MIN(offset, 60);
		scrollView.contentInset = UIEdgeInsetsMake(offset, 0.0f, 0.0f, 0.0f);
		
	} else if (scrollView.isDragging) {
		
		BOOL _loading = NO;
		if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceIsLoading:)]) {
			_loading = [_delegate egoRefreshTableHeaderDataSourceIsLoading:self];
		}
		
		if (_state == EGOOPullRefreshPulling && scrollView.contentOffset.y > -65.0f && scrollView.contentOffset.y < 0.0f && !_loading) {
			[self setState:EGOOPullRefreshNormal];
		} else if (_state == EGOOPullRefreshNormal && scrollView.contentOffset.y < -65.0f && !_loading) {
			[self setState:EGOOPullRefreshPulling];
		}
		
		if (scrollView.contentInset.top != 0) {
			scrollView.contentInset = UIEdgeInsetsZero;
		}
		
	}
	
}

- (void)egoRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView {
	
	BOOL _loading = NO;
	if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceIsLoading:)]) {
		_loading = [_delegate egoRefreshTableHeaderDataSourceIsLoading:self];
	}
	
	if (scrollView.contentOffset.y <= - 65.0f && !_loading) {
		
		if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDidTriggerRefresh:)]) {
			[_delegate egoRefreshTableHeaderDidTriggerRefresh:self];
		}
		
		[self setState:EGOOPullRefreshLoading];
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.2];
		scrollView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
		[UIView commitAnimations];
		
	}
	
}

- (void)egoRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView {	
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:.3];
	[scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
	[UIView commitAnimations];
	
	[self setState:EGOOPullRefreshNormal];

}


#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
	
	_delegate=nil;
	_activityView = nil;
	_statusLabel = nil;
	_arrowImage = nil;
	_lastUpdatedLabel = nil;
	
	[_textColor release];
	[_imgName release];
	
	[_statusReleaseStr release];
	[_statusLoadingStr release];
	[_statusPullStr release];
	[_statusUpdatedStr release];
	
    [super dealloc];
}


@end
