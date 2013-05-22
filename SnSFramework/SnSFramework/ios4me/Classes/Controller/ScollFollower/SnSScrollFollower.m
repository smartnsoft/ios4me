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

#import "SnSScrollFollower.h"
#import "SnSConstants.h"
#import "SnSScrollFollowerView.h"
#import "SnSLog.h"

#define VIEW_X(v)			((v).frame.origin.x)
#define VIEW_Y(v)			((v).frame.origin.y)
#define VIEW_WIDTH(v)		((v).frame.size.width)
#define VIEW_HEIGHT(v)		((v).frame.size.height)

@implementation SnSScrollFollower
@synthesize scrollFollowed = scrollFollowed_;

#pragma mark -
#pragma mark ScollFollower
#pragma mark -

- (void)updateDisplay
{
	
}

#pragma mark -
#pragma mark SnSViewControllerLifeCycle
#pragma mark -

/**
 * Called after the loadView call
 */
- (void)onRetrieveDisplayObjects:(UIView *)view
{
	[super onRetrieveDisplayObjects:view];
	
	// -------------------------
	// Setup View
	// -------------------------
	self.view.frame				= CGRectMake(0, 0, SnSScollFollowerDefaultSize.width, SnSScollFollowerDefaultSize.height);
	self.view.center			= CGPointMake(VIEW_WIDTH(scrollFollowed_)-VIEW_WIDTH(self.view), 0);
	self.view.backgroundColor	= [UIColor clearColor];
	self.view.alpha				= 0.f;
	self.view.clipsToBounds		= YES;
	
	// -------------------------
	// SnSScrollFollowerView
	// -------------------------
	SnSScrollFollowerView* v = [[[SnSScrollFollowerView alloc] initWithFrame:CGRectMake(0,
																						0, //-VIEW_HEIGHT(self.view)*.5f,
																						VIEW_WIDTH(self.view),
																						VIEW_HEIGHT(self.view))] autorelease];
	
	v.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
	[self.view addSubview:v];
	
	// -------------------------
	// Gesture Recognizer
	// -------------------------
	UIPanGestureRecognizer* pan = [[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPan:)] autorelease];
	pan.maximumNumberOfTouches = 1;
	pan.minimumNumberOfTouches = 1;
	
	[v addGestureRecognizer:pan];
}

/**
 * Called after the viewDidLoad call
 */
- (void)onRetrieveBusinessObjects
{	
	[super onRetrieveBusinessObjects];
	
}

/**
 * Called after the viewWillAppear call
 */
- (void)onFulfillDisplayObjects
{
	[super onFulfillDisplayObjects];
	
		
}

/**
 * Called after the viewDidAppear call
 */
- (void)onSynchronizeDisplayObjects
{
	[super onSynchronizeDisplayObjects];
	
}

/**
 * Called after the viewDidUnload call
 */
- (void)onDiscarded
{
	[super onDiscarded];
}

#pragma mark -
#pragma mark Events
#pragma mark -

- (void)onPan:(UIPanGestureRecognizer *)iPanRecognizer
{
	SnSLogD(@"Panning");
	
	panStatus_.location = [iPanRecognizer locationInView:self.view];
		
	// -----------------------------
	// Gesture Began: Setup
	// -----------------------------
	if (iPanRecognizer.state == UIGestureRecognizerStateBegan) 
	{
		panStatus_.direction		= CGPointZero;
		panStatus_.displacement		= 0.f;
		panStatus_.hitLocation		= panStatus_.location;
		panStatus_.lastLocation		= panStatus_.location;
		panStatus_.initialOffset	= scrollFollowed_.contentOffset;
		panStatus_.isPanning		= YES;
		panStatus_.shouldDisapear	= NO;
	}
	
	// -----------------------------
	// Determining Panning Direction
	// -----------------------------
	if (CGPointEqualToPoint(panStatus_.direction, CGPointZero) && iPanRecognizer.state == UIGestureRecognizerStateChanged) 
		panStatus_.direction = CGPointMake(0, panStatus_.location.y > panStatus_.hitLocation.y ? 1.f : -1.f);
	
	// -----------------------------
	// Updating Displacement values
	// -----------------------------
	panStatus_.displacement = panStatus_.location.y - panStatus_.hitLocation.y;
	
	
	CGPoint center = [self safeCenter:CGPointMake(self.view.center.x, self.view.center.y + panStatus_.displacement)];
	
	// Setup vars
	CGFloat h	= scrollFollowed_.bounds.size.height;
	CGFloat he	= VIEW_HEIGHT(self.view);
	CGFloat cy	= center.y;
	
	// The formula to retrieve the ratio (0-1) based ton the current displaced view center
	CGFloat ratio = cy / (h - 2.f*he) - h/(2.f*(h-2.f*he)) + 0.5f;
	
	if (ratio > 1.f)
		ratio = 1.f;
	if (ratio < 0.f)
		ratio = 0.f;
	
	scrollFollowed_.contentOffset = CGPointMake(scrollFollowed_.contentOffset.x, 
												ratio*(scrollFollowed_.contentSize.height-scrollFollowed_.bounds.size.height));
	
	// -----------------------------
	// Gesture Ended: Finish up
	// -----------------------------
	if (iPanRecognizer.state == UIGestureRecognizerStateEnded || iPanRecognizer.state == UIGestureRecognizerStateCancelled) 
	{
		// Panning ended
		panStatus_.isPanning	= NO;
		
		// If dispear was requested make it happen 
		if (panStatus_.shouldDisapear)
			[self disappear];
	
	}

}

#pragma mark -
#pragma mark Scroll Follower 
#pragma mark -

- (CGPoint)safeCenter:(CGPoint)iCenter
{
	CGFloat y = iCenter.y;
	// Readjust position if overflow
	if (y < VIEW_HEIGHT(self.view)*0.5f)
		y = VIEW_HEIGHT(self.view)*0.5f;
	else if (y+VIEW_HEIGHT(self.view)*0.5f > VIEW_HEIGHT(scrollFollowed_))
		y = VIEW_HEIGHT(scrollFollowed_)-VIEW_HEIGHT(self.view)*0.5f;
	
	return CGPointMake(iCenter.x, y);

}
- (void)follow
{
	// No need to go further if the scroll view is not set
	if (!scrollFollowed_)
		return;
	
	// Make the view appear if needed
	if (self.view.alpha == 0)
		[self appear];
	
	
	// the ratio will depend on the view relative position to its window
	CGFloat ratio = [self ratio];
	
	// Calculate the indictor length
	CGFloat length = [self indicatorLength];
	
	CGFloat shift = -length*ratio + length*0.5f;
	
	// calculate the new y position
	CGFloat y = ratio * scrollFollowed_.bounds.size.height + shift;	
	
	// update the view position
	self.view.center = [self safeCenter:CGPointMake(self.view.center.x, y)];
	
}

-(CGFloat)ratio
{
	// should return 0 when the user hasen't scrolled and 1 when the view is completely scrolled
	return scrollFollowed_.contentOffset.y/(scrollFollowed_.contentSize.height-scrollFollowed_.bounds.size.height);
	
}

- (CGFloat)indicatorLength
{
	// Calculate the indicator length
	CGFloat length = scrollFollowed_.bounds.size.height/scrollFollowed_.contentSize.height*scrollFollowed_.bounds.size.height;
	
	// Minimum size is 35px (beware this might change in next version of iOS)
	length = length < 35.f ? 35.f : length;
	
	return length;
}

#pragma mark -
#pragma mark Animation
#pragma mark -

- (void)appear
{
	// No need to go further if the scroll view is not set
	if (scrollFollowed_ == nil)
		return;
	
	CGPoint p = CGPointMake(VIEW_WIDTH(scrollFollowed_)-VIEW_WIDTH(self.view)*0.5-10,self.view.center.y);
	CGFloat s = SnSScollFollowerDefaultAnimationOffset;
	self.view.center = CGPointMake(p.x - s, p.y);
	[UIView animateWithDuration:0.3f
						  delay:0
						options:UIViewAnimationOptionAllowUserInteraction
					 animations:^{
						 self.view.alpha = 1.f;
						 self.view.center = CGPointMake(p.x, self.view.center.y);
					 }
					 completion:nil];
}

- (void)disappear
{
	// If the user is panning the view do not make it disapear just yet
	if (panStatus_.isPanning)
	{
		panStatus_.shouldDisapear = YES;
		return;
	}

	
	CGPoint p = self.view.center;
	CGFloat s = SnSScollFollowerDefaultAnimationOffset;
	[UIView animateWithDuration:0.3f
						  delay:0
						options:UIViewAnimationOptionAllowUserInteraction
					 animations:^{
						 self.view.alpha = 0.f;
						 self.view.center = CGPointMake(p.x-s, self.view.center.y);
					 }
					 completion:^ (BOOL f){
						 if (f)
							 self.view.center = p;
						 
					 }];
}



#pragma mark -
#pragma mark UIViewController
#pragma mark -

#pragma mark Basics

- (void)dealloc
{
	[super dealloc];
}

- (void)didReceiveMemoryWarning
{
	SnSLogW(@"");
	
	[super didReceiveMemoryWarning];
	
}

#pragma mark Rotation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
	return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	SnSLogD(@"");
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	SnSLogD(@"");
}





@end
