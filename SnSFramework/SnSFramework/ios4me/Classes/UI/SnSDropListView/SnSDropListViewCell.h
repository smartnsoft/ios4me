//
//  SnSDropListViewCell.h
//  ios4me
//
//  Created by Johan Attali on 13/06/12.
//  Copyright (c) 2012 Smart&Soft. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SnSDropListViewCell : UIView
{
	UILabel* titleLabel_;	
}
@property (nonatomic, readonly) UILabel* titleLabel;

- (void)setSelected:(BOOL)selected animated:(BOOL)animated;

@end
