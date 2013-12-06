//
//  SnSStackView.m
//  SnSFramework
//
//  Created by Johan Attali on 17/11/11.
//  Copyright (c) 2011 Smart&Soft. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "SnSStackView.h"
#import "SnSLog.h"



@implementation SnSStackView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (UIView *) hitTest: (CGPoint) pt withEvent: (UIEvent *) event 
{   
	UIView* aHitView = [super hitTest:pt withEvent:event];
	
	// This is the  tricky part:
	// We do not want the SnSStackView to catch events.
	//
	// So we need to remove temporarly the SnSStackView so that when we calculate
	// The real hit view we do not go back in an infinite loop
	// (because the parent will ultmiatly call the hit view again at the SnSStackView level)
	if ([aHitView isKindOfClass:[SnSStackView class]])
	{
		UIView* aSuperView = [aHitView superview];
		UIView* aStackView = aHitView;
		[aStackView removeFromSuperview];
		aHitView = [aSuperView hitTest:pt withEvent:event]; 
		[aSuperView addSubview:aStackView];
	}
	
	return aHitView ;	
	
}


@end

@implementation SnSStackSubView

@synthesize framePortrait = _framePortrait;
@synthesize frameLandscape = _frameLandscape;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
	{
		_framePortrait = CGRectZero;
		_frameLandscape = CGRectZero;

        _offsetShiftLandscape = 185;
        _offsetShiftPortrait = 185;
    }
    return self;
}

- (CGFloat)offsetShift
{
    return UIDeviceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]) ? self.offsetShiftPortrait : self.offsetShiftLandscape;
}

- (NSString *)description
{
	NSString* aDes = [super description];
	aDes = [aDes stringByAppendingFormat:@" portrait = (%.0f %.0f; %.0f %.0f) landscape = (%.0f %.0f; %.0f %.0f)",
			_framePortrait.origin.x,_framePortrait.origin.y,_framePortrait.size.width,_framePortrait.size.height,
			_frameLandscape.origin.x,_frameLandscape.origin.y,_frameLandscape.size.width,_frameLandscape.size.height];
	
	return aDes;

}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end

@implementation UIView (SnSStackSubView)

- (id)viewConvertedToClass:(Class)iClass
{
	UIView* aNewView = self;
	// If user forgot to set the view to be a SnSStackView replace the current view
	// with a newly allolcated SnSStackView
	if (![self isKindOfClass:[iClass class]])
	{
		aNewView = [[[iClass alloc] initWithFrame:self.frame] autorelease];
		aNewView.autoresizingMask = self.autoresizingMask;
		aNewView.autoresizesSubviews = self.autoresizesSubviews;
		aNewView.clipsToBounds = self.clipsToBounds;
		
		aNewView.layer.cornerRadius = self.layer.cornerRadius;
		aNewView.layer.borderColor = self.layer.borderColor;
		aNewView.layer.shadowColor = self.layer.shadowColor;
		aNewView.layer.shadowOffset = self.layer.shadowOffset;
		aNewView.layer.shadowOpacity = self.layer.shadowOpacity;
		aNewView.layer.shadowPath = self.layer.shadowPath;
		aNewView.layer.shadowRadius = self.layer.shadowRadius;


		
		// Move previous subviews to new view
		for (UIView* aSubView in [self subviews])
		{
			[aSubView removeFromSuperview];
			[aNewView addSubview:aSubView];
		}		
		
		// Move previous gesture recognizers to new view
		for (UIGestureRecognizer* aGS in [self gestureRecognizers])
		{
			[self removeGestureRecognizer:aGS];
			[aNewView addGestureRecognizer:aGS];
		}
	}
	
	return aNewView;

}

- (CGRect)framePortrait
{
	SnSLogW(@"Warning: The current view %@ is not of exptected class %@", self.class, [SnSStackSubView class]);
	return self.frame;
}

- (CGRect)frameLandscape
{
	SnSLogW(@"Warning: The current view %@ is not of exptected class %@", self.class, [SnSStackSubView class]);
	return self.frame;
}

- (void)setFramePortrait:(CGRect)iFrame
{
	SnSLogW(@"Warning: The current view %@ is not of exptected class %@", self.class, [SnSStackSubView class]);
}

- (void)setFrameLandscape:(CGRect)iFrame
{
	SnSLogW(@"Warning: The current view %@ is not of exptected class %@", self.class, [SnSStackSubView class]);
}
@end
