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
@synthesize backgroundView = backgroundView_;
@synthesize enabled = enabled_;
@synthesize arrowImage = imgArrow_;
@synthesize backgroundImage = imgBackground_;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
	
    if (self) 
		[self setup];
	
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	
	if (self)
		[self setup];
	
	return self;
}

- (void)setup
{
	// -----------------------------
	// 
	// -----------------------------
	self.clipsToBounds = NO;
	self.userInteractionEnabled = YES;
	self.backgroundColor = [UIColor whiteColor];
	self.layer.cornerRadius = 4.f;
	self.enabled = YES;
	
	// -----------------------------
	// Configure Sub Views
	// -----------------------------
	
	backgroundView_ = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, SnSViewW(self), SnSViewH(self))] autorelease];
	backgroundView_.backgroundColor = [UIColor clearColor];
	
	mainLabel_ = [[[UILabel alloc] initWithFrame:CGRectMake(10, 0, SnSViewW(self)-10, SnSViewH(self))] autorelease];
	mainLabel_.backgroundColor = [UIColor clearColor];
	
	scrollview_ = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, 0)];
	scrollview_.backgroundColor = [UIColor whiteColor];
	scrollview_.userInteractionEnabled = YES;
	
	imgBackground_ = [[[UIImageView alloc] initWithFrame:(CGRect){0, 0, self.frame.size}] autorelease];
	imgBackground_.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	
	imgArrow_ = [[[UIImageView alloc] initWithFrame:CGRectZero] autorelease];
	imgArrow_.frame = CGRectMake(SnSViewW(backgroundView_) - (SnSViewW(imgArrow_) + 8), 10, SnSViewW(imgArrow_), SnSViewH(imgArrow_));
	
	[self.backgroundView addSubview:imgBackground_];
	[self.backgroundView addSubview:imgArrow_];
    
	[self addSubview:backgroundView_];
	[self addSubview:mainLabel_];
	
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
	if (!enabled_)
		return;
	
	if ([delegate_ respondsToSelector:@selector(didTapDropListView:)])
		[delegate_ didTapDropListView:self];
	
	if (SnSViewH(scrollview_) == 0)
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

#pragma mark -
#pragma mark Building views
#pragma mark -

- (void)openScrollView
{	
	if (!enabled_)
		return;
	
	
	// warn delegate scroll view is about to open
	if ([delegate_ respondsToSelector:@selector(dropList:willOpenScrollView:)])
		[delegate_ dropList:self willOpenScrollView:scrollview_];
	
	scrollview_.layer.shadowRadius = 50;
	scrollview_.layer.shadowOpacity = 1;
	scrollview_.layer.shadowOffset = CGSizeMake(1, 50);
	scrollview_.layer.shadowColor = [UIColor blackColor].CGColor;
	scrollview_.layer.shadowPath = [UIBezierPath bezierPathWithRect:scrollview_.bounds].CGPath;
	
//	// update frame
//	scrollview_.frame = CGRectMake(SnSViewX(scrollview_), 
//								   SnSViewY(scrollview_)+SnSViewH(scrollview_), 
//								   SnSViewW(scrollview_), 
//								   0);

	// animate
	[UIView animateWithDuration:0.3f
					 animations:^{
						 scrollview_.frame = CGRectMake(SnSViewX(scrollview_),
														SnSViewY(scrollview_), 
														SnSViewW(scrollview_),
														expectedHeight_);
					 }
					 completion:^(BOOL f){
						 if (f && [delegate_ respondsToSelector:@selector(dropList:didOpenScrollView:)] )
							 [delegate_ dropList:self didOpenScrollView:scrollview_];
					 }];
		
//	
//	// add to parent subview
//	[[self superview] addSubview:scrollview_];

}

- (void)closeScrollView
{
	// warn delegate scroll view is about to close
	if ([delegate_ respondsToSelector:@selector(dropList:willCloseScrollView:)])
		[delegate_ dropList:self willCloseScrollView:scrollview_];
	
	
	scrollview_.layer.shadowOpacity = 0.0f;
	
	// remove all previous animations
	[scrollview_.layer removeAllAnimations];
	
	// animate move back and when done, remove from super view
	[UIView animateWithDuration:0.3f
					 animations:^{
						 scrollview_.frame = CGRectMake(SnSViewX(scrollview_), SnSViewY(scrollview_), SnSViewW(scrollview_), 0);
					 }
					 completion:^(BOOL f){
						 if (f)
							 [scrollview_ removeFromSuperview];
						 if (f && [delegate_ respondsToSelector:@selector(dropList:didCloseScrollView:)] )
							 [delegate_ dropList:self didCloseScrollView:scrollview_];

					 }];
}

- (NSInteger)selectedRow
{
	return [[scrollview_ subviews] indexOfObject:selectedCell_];
}

- (void)selectRow:(NSInteger)index
{
	SnSDropListViewCell* cell = nil;
	if (index >= 0 && index < [[scrollview_ subviews] count])
		cell = [[scrollview_ subviews] objectAtIndex:index];
	
	[cell setSelected:YES animated:YES];
	selectedCell_ = cell;
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
	
	// Update expectedHeight used for future animation
	expectedHeight_ = SnSViewH(scrollview_);
	
	// put scroll view height back to 0
	scrollview_.frame = CGRectMake(SnSViewX(scrollview_), SnSViewY(scrollview_), SnSViewW(scrollview_), 0);
	
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




@end
