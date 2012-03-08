//
//  ImageRetrievallCellView.m
//  Test-SnSFramework
//
//  Created by Johan Attali on 07/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ImageRetrievallCellView.h"
#import "AutomationServices.h"

#define VIEW_X(v)			((v).frame.origin.x)
#define VIEW_Y(v)			((v).frame.origin.y)
#define VIEW_WIDTH(v)		((v).frame.size.width)
#define VIEW_HEIGHT(v)		((v).frame.size.height)

@implementation ImageRetrievallCellView

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		imgThumbnail_ = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 120, kImageRetrievalCellHeight)];
		[imgThumbnail_ setContentMode:UIViewContentModeScaleAspectFit];
		
		actLoader_  = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		[actLoader_ setCenter:imgThumbnail_.center];
		[actLoader_ setHidesWhenStopped:YES];
		
		lblTitle_ = [[UILabel alloc] initWithFrame:CGRectMake(125, 0, VIEW_WIDTH(self)-125, kImageRetrievalCellHeight)];
		[lblTitle_ setTextColor:[UIColor blackColor]];
		[lblTitle_ setNumberOfLines:0];
		[lblTitle_ setFont:[UIFont fontWithName:@"Helvetica" size:11]];
		
		[self addSubview:actLoader_];
		[self addSubview:imgThumbnail_];
		[self addSubview:lblTitle_];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)dealloc
{
	[imgThumbnail_ release];
	[lblTitle_ release];
	[actLoader_ release];
	
	[super dealloc];
}

#pragma mark -
#pragma mark Load Cell


- (void)loadWithBusinessObject:(id)iObj
{
	SnSLogD(@"Loading cell %p with business object: %@", self, iObj);

	NSString* aURLStr = (NSString*)iObj;
	
	imgThumbnail_.image = nil;
	lblTitle_.text = aURLStr;
	
	[[AutomationRemoteServices instance] retrieveImageURL:[NSURL URLWithString:aURLStr]
												  binding:imgThumbnail_
												indicator:actLoader_];
	
	
}
@end
