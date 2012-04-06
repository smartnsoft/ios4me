//
//  SnSScrollFollowerView.h
//  ios4me
//
//  Created by Johan Attali on 06/04/12.
//  Copyright (c) 2012 Smart&Soft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SnSScrollFollowerView : UIView
{
	UIScrollView* scrollFollowed_;
}

/**
 * @property The scroll view that this view will be following
 */
@property (nonatomic, assign) UIScrollView* scrollFollowed;

/**
 * Designated Initalizer
 * @param frame The usual frame parameter
 * @param iScrollView The scroll view that will be attached to the follower
 */
- (id)initWithFrame:(CGRect)frame scrollView:(UIScrollView*)iScrollView;

/**
 * Tells the view to updates its position based on the scroll view its is attached to
 * The math to update correctly the position is done internally in this method
 */
- (void)follow;

/**
 * Returns the current ratio of scrolling. 
 * That is the the content offset divided by corrected content size
 */
- (CGFloat)ratio;

/**
 * Returns the calculated indicator length of the scrollview
 */
- (CGFloat)indicatorLength;

/**
 * So far on all version of iOS the content size of the scroll view is always
 * incremented by a specific value.
 * This is probably used for bouncing but nevertheless we need to take it into
 * consideration in our math
 */
- (CGFloat)customOverSize;

@end
