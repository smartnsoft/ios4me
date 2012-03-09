//
//  ImageRetrievallCellView.h
//  Test-SnSFramework
//
//  Created by Johan Attali on 07/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kImageRetrievalCellHeight 80

@interface ImageRetrievallCellView : UITableViewCell
{
	UIImageView* imgThumbnail_;
	UIActivityIndicatorView* actLoader_;
	UILabel* lblTitle_;
}

- (void)loadWithBusinessObject:(id)iObj;

@end
