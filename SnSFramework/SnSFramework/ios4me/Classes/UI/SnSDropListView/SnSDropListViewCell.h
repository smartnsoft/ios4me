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
    
    // custon label
    UIColor* titleLabelDefaultColor_;
    UIColor* titleLabelSelectedColor_;
    UIColor* backgroundSelectedColor_;
    UIFont* titleLabelFont_;
}
@property (nonatomic, readonly) UILabel* titleLabel;
@property (nonatomic, retain) UIColor* titleLabelDefaultColor;
@property (nonatomic, retain) UIColor* titleLabelSelectedColor;
@property (nonatomic, retain) UIColor* backgroundSelectedColor;
@property (nonatomic, retain) UIFont* titleLabelFont;


- (void)setSelected:(BOOL)selected animated:(BOOL)animated;

@end
