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


#import <UIKit/UIKit.h>
#import "SnSViewController.h"

typedef struct SnSScrollFollowerPanStatus
{
	CGFloat		displacement;
	CGPoint		initialOffset;
	CGPoint		location;
	CGPoint		hitLocation;
	CGPoint		lastLocation;
	CGPoint		direction;	
	BOOL		isPanning;
	BOOL		shouldDisapear;
	
	
} SnSScrollFollowerPanStatus;

@interface SnSScrollFollower : SnSViewController 
{
	UIScrollView* scrollFollowed_;
	
	SnSScrollFollowerPanStatus panStatus_;
}

/**
 * @property The scroll view that this view will be following
 */
@property (nonatomic, assign) UIScrollView* scrollFollowed;

- (void)appear;
- (void)disappear;

/**
 * Tells the view to updates its position based on the scroll view its is attached to
 * The math to update correctly the position is done internally in this method.
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

- (CGPoint)safeCenter:(CGPoint)iCenter;

#pragma mark Events

- (void)onPan:(UIPanGestureRecognizer*)iPanRecognizer;

@end

