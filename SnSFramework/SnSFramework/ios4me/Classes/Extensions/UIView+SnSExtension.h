//
//  UIView+SnSExtension.h
//  ios4me
//
//  Created by Johan Attali on 29/05/12.
//  Copyright (c) 2012 Smart&Soft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (SnSExtension)

- (void)localizeRecursively;
- (NSArray*)subviewsOfClass:(Class)iClass;
- (NSArray*)subviewsDesired;
- (void)applyBlockRecursively:(void (^)(id))block stop:(BOOL*)stop;

- (UIView*)rootview;
- (UIView*)superviewOfClass:(Class)iClass;

#pragma mark Animations

+ (void)animateWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay animations:(void (^)(void))animations;
- (void)animateWithBounceEffect;

@end
