//
//  SnSDropListViewCell.m
//  ios4me
//
//  Created by Johan Attali on 13/06/12.
//  Copyright (c) 2012 Smart&Soft. All rights reserved.
//

#import "SnSDropListViewCell.h"

#define kCellBackgroundSelectedColor RGB(2,50,63)
#define kCellBackgroundDefaultColor RGB(255,255,255)
#define kCellTextDefaultColor RGB(0,0,0)
#define kCellTextSelectedColor RGB(255,255,255)

@implementation SnSDropListViewCell
@synthesize titleLabel = titleLabel_;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
	{
        titleLabel_ = [[[UILabel alloc] initWithFrame:CGRectMake(10, 0, frame.size.width-10, frame.size.height)] autorelease];
		titleLabel_.textColor = [UIColor blackColor];
		titleLabel_.backgroundColor = kCellTextDefaultColor;
		
		[self addSubview:titleLabel_];
		
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
	if (selected)
	{
		self.backgroundColor = kCellBackgroundSelectedColor;
		
		titleLabel_.backgroundColor = kCellBackgroundSelectedColor;
		titleLabel_.textColor = kCellTextSelectedColor;
	}
	else 
	{
		self.backgroundColor = kCellBackgroundDefaultColor;
		
		titleLabel_.backgroundColor = kCellBackgroundDefaultColor;
		titleLabel_.textColor = kCellTextDefaultColor;
	}
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
