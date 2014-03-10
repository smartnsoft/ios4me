/*
 * (C) Copyright 2009-2011 Smart&Soft SAS (http://www.smartnsoft.com/) and contributors.
 *
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the GNU Lesser General Public License
 * (LGPL) version 3.0 which accompanies this distribution, and is available at
 * http://www.gnu.org/licenses/lgpl.html
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * Lesser General Public License for more details.
 *
 * Contributors:
 *     Smart&Soft - initial API and implementation
 * Creator:
 *     Johan Attali
 */

#import "SnSScrollFollowerView.h"
#import "SnSConstants.h"
#define VIEW_X(v)			((v).frame.origin.x)
#define VIEW_Y(v)			((v).frame.origin.y)
#define VIEW_WIDTH(v)		((v).frame.size.width)
#define VIEW_HEIGHT(v)		((v).frame.size.height)

@implementation SnSScrollFollowerView

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self)
	{
		self.clipsToBounds = YES;
		self.backgroundColor = [UIColor clearColor];
	}
	
	return self;
}

- (void)drawRect:(CGRect)rect
{
	UIColor* bgColor = [UIColor colorWithRed:20.f/255.f green:20.f/255.f blue:20.f/255.f alpha:0.8f];
	
	UIBezierPath* p = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(self.frame.origin.x, 
													   self.frame.origin.y,
													   self.frame.size.width-SnSScollFollowerDefaultIndicatorLength,
													   self.frame.size.height)
						  byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerTopLeft
								cornerRadii:CGSizeMake(8, 8)];
	
//	UIBezierPath* p = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(self.frame.origin.x, 
//																		self.frame.origin.y,
//																		self.frame.size.width-SnSScollFollowerDefaultIndicatorLength,
//																		self.frame.size.height)
//												cornerRadius:7.f];
	
	CGFloat w = SnSScollFollowerDefaultIndicatorLength, s = VIEW_HEIGHT(self);
	[p moveToPoint:CGPointMake(VIEW_WIDTH(self)-w, VIEW_HEIGHT(self)*0.5f-s*0.5f)];
	[p addLineToPoint:CGPointMake(VIEW_WIDTH(self), VIEW_HEIGHT(self)*0.5f)];
	[p addLineToPoint:CGPointMake(VIEW_WIDTH(self)-w, VIEW_HEIGHT(self)*0.5f+s*0.5f)];
	[bgColor setFill];
	[p fill];
}

@end
