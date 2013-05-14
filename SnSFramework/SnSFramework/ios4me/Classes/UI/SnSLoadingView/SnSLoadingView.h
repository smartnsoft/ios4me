//
//  SnSLoadingView.h
//  ios4me
//
//  Created by Johan Attali on 06/03/12.
//  Copyright (c) 2012 Smart&Soft. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SnSLoadingAnimationBlock)(void);

@interface SnSLoadingView : UIView
{
	NSArray* images_;
	
	BOOL isAnimating_;
	BOOL hidesWhenStopped_;
	
	SnSLoadingAnimationBlock animationBlock_;
}

@property (nonatomic, readonly) BOOL isAnimating;
@property (nonatomic, assign) BOOL hidesWhenStopped;
@property (nonatomic, retain) NSArray* images;
@property (nonatomic, copy) SnSLoadingAnimationBlock animationBlock;

- (void)setup;
- (void)startAnimating;
- (void)stopAnimating;

#pragma mark Custom 


@end
