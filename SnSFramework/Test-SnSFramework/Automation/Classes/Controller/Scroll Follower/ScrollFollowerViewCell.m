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

#import "ScrollFollowerViewCell.h"

#import "ScrollFollowerRemoteServices.h"

@implementation ScrollFollowerViewCell

@synthesize firstText;
@synthesize lastText;
@synthesize imgName;
@synthesize lblFirst;
@synthesize lblText;
@synthesize imgTest;
@synthesize img = img_;

static UIFont *firstTextFont = nil;
static UIFont *lastTextFont = nil;

+ (void)initialize
{
	if(self == [ScrollFollowerViewCell class])
	{
		firstTextFont = [[UIFont systemFontOfSize:20] retain];
		lastTextFont = [[UIFont boldSystemFontOfSize:20] retain];		
		
		// this is a good spot to load any graphics you might be drawing in -drawContentView:
		// just load them and retain them here (ONLY if they're small enough that you don't care about them wasting memory)
		// the idea is to do as LITTLE work (e.g. allocations) in -drawContentView: as possible
	}
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
	{
		contentView = [[UITableViewCell alloc] initWithFrame:CGRectZero];
		contentView.opaque = YES;
		[self addSubview:contentView];
		[contentView release];
    }
    return self;}



- (void)dealloc
{
	[firstText release];
	[lastText release];
	[imgName release];
	[lblFirst release];
	[lblText release];
	[imgTest release];
	
    [super dealloc];
}

// the reason I don't synthesize setters for 'firstText' and 'lastText' is because I need to 
// call -setNeedsDisplay when they change

- (void)setFirstText:(NSString *)s
{
	[firstText release];
	firstText = [s copy];
	[self setNeedsDisplay]; 
}

- (void)setLastText:(NSString *)s
{
	[lastText release];
	lastText = [s copy];
	[self setNeedsDisplay]; 
}


- (void)layoutSubviews
{
	CGRect b = [self bounds];
	b.size.height -= 1; // leave room for the separator line
	b.size.width += 30; // allow extra width to slide for editing
	b.origin.x -= (self.editing && !self.showingDeleteConfirmation) ? 0 : 30; // start 30px left unless editing
	[contentView setFrame:b];
    [super layoutSubviews];
}

- (void)drawRect:(CGRect)r
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	UIColor *backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
	UIColor *textColor = [UIColor blackColor];
	
	if(self.selected)
	{
		backgroundColor = [UIColor clearColor];
		textColor = [UIColor whiteColor];
	}
	
	[backgroundColor set];
	CGContextFillRect(context, r);
	
	CGPoint p;
	p.x = 42;
	p.y = 9;
	
	[textColor set];
	CGSize s = [firstText drawAtPoint:p withFont:firstTextFont];
	
	p.x += s.width + 6; // space between words
	[lastText drawAtPoint:p withFont:lastTextFont];
	
	if (img_)
		[img_ drawInRect:CGRectMake(r.size.width-100, 0, 100, self.bounds.size.height)];


}

- (void)downloadImage
{
	self.img = nil;
	[[ScrollFollowerRemoteServices instance] retrieveImageURL:[NSURL URLWithString:imgName]
													  binding:(UIImageView*)self
													indicator:nil
											  completionBlock:^(UIImage* image){
												  
												  self.img = image; //[image imageScaledToSize:CGSizeMake(80, 45)];
												  
												  [self setNeedsDisplay];
												  
											  }
												   errorBlock:nil];


}

@end
