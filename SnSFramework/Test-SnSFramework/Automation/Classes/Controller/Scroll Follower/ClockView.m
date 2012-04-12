//
//  ClockView.m
//  Test-SnSFramework
//
//  Created by Johan Attali on 12/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ClockView.h"

#define VIEW_X(v)			((v).frame.origin.x)
#define VIEW_Y(v)			((v).frame.origin.y)
#define VIEW_WIDTH(v)		((v).frame.size.width)
#define VIEW_HEIGHT(v)		((v).frame.size.height)

#define kClockViewStrokeSize 2.f
#define kClockViewStrokeColor RGBA(166, 0, 7, 1)

@implementation ClockView

@synthesize viewHour = viewHour_;
@synthesize viewMinute = viewMinute_;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		self.backgroundColor = [UIColor clearColor];
		
	
		CGFloat w = frame.size.width;
		CGFloat l = w*0.26f;
		CGFloat s = kClockViewStrokeSize;
		CGPoint center = CGPointMake(w*0.5f, w*0.5f-l*0.5f);
		CGPoint rot = CGPointMake(w*0.5f, w*0.5f);
		
		viewHour_ = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, s, l)] autorelease];
		viewHour_.backgroundColor = kClockViewStrokeColor;
		viewHour_.center = center;
		viewHour_.layer.cornerRadius = 1.f;
		viewHour_.clipsToBounds = YES;
		[self addSubview:viewHour_];
		
		CATransform3D transform = CATransform3DIdentity;
		transform = CATransform3DTranslate(transform, rot.x-center.x, rot.y-center.y, 0.0);
		transform = CATransform3DRotate(transform, -M_PI_2, 0.0, 0.0, -1.0);
		transform = CATransform3DTranslate(transform, center.x-rot.x, center.y-rot.y, 0.0);
		
		viewHour_.layer.transform = transform;
		
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
//	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGFloat w =  VIEW_HEIGHT(self);
	CGFloat s = kClockViewStrokeSize;
	UIColor* grayColor = RGBA(10, 10, 10, 1);
	UIColor* redColor	= RGBA(166, 0, 7, 1);

	[grayColor setFill];
	[redColor setStroke];
	
	UIBezierPath *circle = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(s, s,w-2*s, w-2*s)];
	circle.lineWidth = 2.f;
	[circle fill];
	[circle stroke];
	
//	CGPoint center = CGPointMake((w-s)*0.5f, (w-s)*0.5f);
//	
//	UIBezierPath *hour = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(center.x,
//																			center.y,
//																			s,
//																			(w-8*s)*0.5f)
//											   byRoundingCorners:UIRectCornerTopLeft
//													 cornerRadii:CGSizeMake(1, 1)];
//	[redColor setFill];
//	[hour fill];
//	
//	CATransform3D transform = CATransform3DIdentity;
//	transform = CATransform3DTranslate(transform, rotationPoint.x-self..x, rotationPoint.y-CC.y, 0.0);
//	transform = CATransform3DRotate(transform, rotationAngle, 0.0, 0.0, -1.0);
//	transform = CATransform3DTranslate(transform, CC.x-rotationPoint.x, CC.y-rotationPoint.y, 0.0);

}

@end
