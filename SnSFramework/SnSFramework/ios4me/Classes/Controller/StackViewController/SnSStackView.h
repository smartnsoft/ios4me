//
//  SnSStackView.h
//  SnSFramework
//
//  Created by Johan Attali on 17/11/11.
//  Copyright (c) 2011 Smart&Soft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SnSStackView : UIView

@end


@interface SnSStackSubView : UIView 
{
	CGRect	_framePortrait;
	CGRect	_frameLandscape;
}

@property (nonatomic, assign) CGRect framePortrait;
@property (nonatomic, assign) CGRect frameLandscape;

@end

@interface UIView (SnSStackSubView)

- (CGRect)framePortrait;
- (CGRect)frameLandscape;

- (void)setFramePortrait:(CGRect)iFrame;
- (void)setFrameLandscape:(CGRect)iFrame;

- (id)viewConvertedToClass:(Class)iClass;

@end
