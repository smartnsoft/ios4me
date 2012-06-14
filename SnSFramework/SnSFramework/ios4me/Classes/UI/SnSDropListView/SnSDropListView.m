//
//  SnSDropListView.m
//  ios4me
//
//  Created by Johan Attali on 12/06/12.
//  Copyright (c) 2012 Smart&Soft. All rights reserved.
//

#import "SnSDropListView.h"
#import "SnSDropListViewCell.h"

#define SnSViewX(v)			((v).frame.origin.x)
#define SnSViewY(v)			((v).frame.origin.y)
#define SnSViewW(v)			((v).frame.size.width)
#define SnSViewH(v)			((v).frame.size.height)

#define kSnSDropListLabelDefaulttHeight 30.f

@implementation SnSDropListView
@synthesize delegate = delegate_;
@synthesize dataSource = dataSource_;
@synthesize maxScrollHeight = maxScrollHeight_;
@synthesize mainLabel = mainLabel_;
@synthesize scrollView = scrollview_;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
	
    if (self) 
		[self setup];
	
    return self;
}

- (void)setup
{
	self.clipsToBounds = NO;
	self.userInteractionEnabled = YES;
	self.backgroundColor = [UIColor whiteColor];
	
	// -----------------------------
	// Configure Sub Views
	// -----------------------------
	mainLabel_ = [[[UILabel alloc] initWithFrame:CGRectMake(10, 0, SnSViewW(self)-10, SnSViewH(self))] autorelease];
	mainLabel_.backgroundColor = [UIColor clearColor];
	
	self.layer.cornerRadius = 4.f;
	
	scrollview_ = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, 0)];
	scrollview_.backgroundColor = [UIColor whiteColor];
	scrollview_.hidden = YES;
	scrollview_.userInteractionEnabled = YES;


	[self addSubview:mainLabel_];
	[self addSubview:scrollview_];
	
//	// -----------------------------
//	// Layers
//	// -----------------------------
//	UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:mainLabel_.bounds 
//												   byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)
//														 cornerRadii:CGSizeMake(4, 4)];
//	CAShapeLayer *maskLayer = [CAShapeLayer layer];
//	maskLayer.frame = mainLabel_.bounds;
//	maskLayer.path = maskPath.CGPath;
//	maskLayer.backgroundColor = [UIColor whiteColor].CGColor;
//	[self.layer addSublayer:maskLayer];
//	
	// -----------------------------
	// Configure Gesture Recognizer
	// -----------------------------
	UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapMainView_:)];
	tap.numberOfTapsRequired = 1;
	
	[self addGestureRecognizer:tap];
	
	[tap release];
	
	// -----------------------------
	// Default Variables
	// -----------------------------
	maxScrollHeight_ = 120.f;

}

- (void)dealloc
{
	self.delegate = nil;
	self.dataSource = nil;
	
	SnSReleaseAndNil(scrollview_);
	
	[super dealloc];
}

#pragma mark -
#pragma mark Events
#pragma mark -

- (void)onTapMainView_:(id)sender
{
	if (scrollview_.hidden == YES)
		[self openScrollView];
	else
		[self closeScrollView];
}

- (void)onTapCellView_:(id)sender
{
	SnSDropListViewCell* cell = (SnSDropListViewCell*)[sender view];
	
	// set previous seletected cell to unselected
	[selectedCell_ setSelected:NO animated:YES];
	
	// update current selected cell
	if ([cell isKindOfClass:[SnSDropListViewCell class]])
	{
		selectedCell_ = cell;
		[selectedCell_ setSelected:YES animated:YES];
	}
	
	// update main label (default behaviour)
	mainLabel_.text = selectedCell_.titleLabel.text;
		
	// retreive index of selected cell
	NSInteger idx = [[scrollview_ subviews] indexOfObject:cell];
	
	// call delegate and hit didSelectRow method
	if ([delegate_ respondsToSelector:@selector(dropList:didSelectRow:)])
		[delegate_ dropList:self didSelectRow:idx];
	
	SnSLogD(@"Tapped %d cell", idx);

}

- (void)onTapLabel_:(id)sender
{
	if (scrollview_.hidden == YES)
		[self openScrollView];
	else
		[self closeScrollView];
}

#pragma mark -
#pragma mark Building views
#pragma mark -

- (void)openScrollView
{
	scrollview_.hidden = NO;
	scrollview_.frame = CGRectMake(SnSViewX(self)-0, SnSViewY(self)+SnSViewH(self)-1, SnSViewW(self), SnSViewH(scrollview_));
	
	scrollview_.layer.shadowRadius = 50;
	scrollview_.layer.shadowOpacity = 1;
	scrollview_.layer.shadowOffset = CGSizeMake(1, 50);
	scrollview_.layer.shadowColor = [UIColor blackColor].CGColor;
	scrollview_.layer.shadowPath = [UIBezierPath bezierPathWithRect:scrollview_.bounds].CGPath;
	
//	self.frame = CGRectMake(SnSViewX(self), SnSViewY(self), SnSViewW(self), SnSViewH(scrollview_)+SnSViewH(mainLabel_));
	
	[[self superview] addSubview:scrollview_];

}

- (void)closeScrollView
{
	scrollview_.hidden = YES;
	scrollview_.layer.shadowOpacity = 0.0f;
	
//	self.frame = CGRectMake(SnSViewX(self), SnSViewY(self), SnSViewW(self), SnSViewH(scrollview_));

	[scrollview_ removeFromSuperview];
}

- (void)reloadData
{
	if (!delegate_ || !dataSource_)
		return;
	
	
	// -----------------------------
	// Measurement
	// -----------------------------
	CGFloat height = 0.0f;
	NSInteger rows = 0;
	CGFloat y = 0;
	
	if ([dataSource_ respondsToSelector:@selector(numberOfRowsInDropList:)])
		rows = [dataSource_ numberOfRowsInDropList:self];
	
	if ([delegate_ respondsToSelector:@selector(dropList:heightForRow:)])
	{
		for (NSInteger i = 0; i < rows; ++i)
			height += [delegate_ dropList:self heightForRow:i];
	}
	else
		height = rows*kSnSDropListLabelDefaulttHeight;
	
	// -----------------------------
	// Update Scroll View
	// -----------------------------	
	[[scrollview_ subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];

	scrollview_.frame = CGRectMake(SnSViewX(scrollview_), 
								   SnSViewY(scrollview_), 
								   SnSViewW(scrollview_),
								   height > maxScrollHeight_ ? maxScrollHeight_ : height);
	
	scrollview_.contentSize = CGSizeMake(SnSViewX(scrollview_), height);	
	
	// -----------------------------
	// Build Scroll View
	// -----------------------------
	for (NSInteger i = 0; i < rows; ++i)
	{
		SnSDropListViewCell* cell = nil;
		
		if ([delegate_ respondsToSelector:@selector(dropList:cellForRow:)])
			cell = [delegate_ dropList:self cellForRow:i];
		
		if ([delegate_ respondsToSelector:@selector(dropList:heightForRow:)])
			height = [delegate_ dropList:self heightForRow:i];
		else
			height = kSnSDropListLabelDefaulttHeight;
				
		// Update frame
		cell.userInteractionEnabled = YES;
		cell.frame = CGRectMake(0, y, SnSViewW(scrollview_), height);
		
		// add gesture recognizer
		UITapGestureRecognizer* tap = [[[UITapGestureRecognizer alloc] initWithTarget:self
																			  action:@selector(onTapCellView_:)] autorelease];
		tap.numberOfTapsRequired = 1;
		[cell addGestureRecognizer:tap];
				
		// add to subview
		[scrollview_ addSubview:cell];
		
		// update new position
		y += height;

		
	}
	
	
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	SnSLogD(@"");
}

//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
//{
//	return self;
//}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
	return [super pointInside:point withEvent:event];
}
@end
