//
//  SnSDropListViewCell.m
//  ios4me
//
//  Created by Johan Attali on 13/06/12.
//  Copyright (c) 2012 Smart&Soft. All rights reserved.
//

#import "SnSDropListViewCell.h"

#define kCellBackgroundSelectedColor RGB(2,50,63)
#define kCellBackgroundDefaultColor [UIColor clearColor]
#define kCellTextDefaultColor RGB(0,0,0)
#define kCellTextSelectedColor RGB(255,255,255)

@implementation SnSDropListViewCell
@synthesize titleLabel = titleLabel_;
@synthesize titleLabelDefaultColor = titleLabelDefaultColor_;
@synthesize titleLabelSelectedColor = titleLabelSelectedColor_;
@synthesize backgroundSelectedColor = backgroundSelectedColor_;
@synthesize titleLabelFont = titleLabelFont_;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
	{
        titleLabel_ = [[[UILabel alloc] initWithFrame:CGRectMake(10, 0, frame.size.width-10, frame.size.height)] autorelease];
        titleLabel_.textColor = [UIColor blackColor];
		titleLabel_.backgroundColor = kCellBackgroundDefaultColor;
		
		[self addSubview:titleLabel_];
		
    }
    return self;
}

-(void)dealloc
{
    self.titleLabelDefaultColor = nil;
    self.titleLabelSelectedColor = nil;
    self.backgroundSelectedColor = nil;
    self.titleLabelFont = nil;
    
    [super dealloc];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
	if (selected)
	{
		self.backgroundColor = backgroundSelectedColor_;
		
		titleLabel_.backgroundColor = backgroundSelectedColor_;
		titleLabel_.textColor = titleLabelSelectedColor_;
	}
	else 
	{
		self.backgroundColor = kCellBackgroundDefaultColor;
		
		titleLabel_.backgroundColor = kCellBackgroundDefaultColor;
		titleLabel_.textColor = titleLabelDefaultColor_;
	}
}

- (void)setFrame:(CGRect)frame
{
	[super setFrame:frame];
	
	if (titleLabel_)
		titleLabel_.frame = CGRectMake(10, 
									   0, 
									   frame.size.width-10, 
									   frame.size.height);
}


-(void)setTitleLabelDefaultColor:(UIColor *)titleLabelDefaultColor
{
    SnSReleaseAndNil(titleLabelDefaultColor_);
    
    titleLabelDefaultColor_ = [titleLabelDefaultColor retain];
    
    titleLabel_.textColor = titleLabelDefaultColor_;
}

-(void)setTitleLabelFont:(UIFont *)titleLabelFont
{
    SnSReleaseAndNil(titleLabelFont_);
    
    titleLabelFont_ = [titleLabelFont retain];
    
    titleLabel_.font = titleLabelFont_;
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
