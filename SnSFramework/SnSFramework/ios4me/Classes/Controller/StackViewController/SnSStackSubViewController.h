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
 */

#import <UIKit/UIKit.h>
#import "SnSViewController.h"

@class SnSStackSubView;
@class SnSStackViewController;

@interface SnSStackSubViewController : SnSViewController 
{
	CGRect	_framePortrait;
	CGRect	_frameLandscape;
	
    CGFloat _offsetShiftPortrait;
    CGFloat _offsetShiftLandscape;
    
	SnSStackViewController* _stackController;
		
	BOOL _isShifted;
    
	BOOL _enablePan;
    BOOL _enableShadow;
}

@property (nonatomic, assign) BOOL defaultShadow;
@property (nonatomic, retain) CALayer *shadowLayer;

@property (nonatomic, assign) CGFloat offsetShiftPortrait;
@property (nonatomic, assign) CGFloat offsetShiftLandscape;

@property (nonatomic, assign) CGRect framePortrait;
@property (nonatomic, assign) CGRect frameLandscape;

@property (nonatomic, assign) SnSStackViewController* stackController;
@property (nonatomic, assign, getter = isPanEnabled) BOOL enablePan;
@property (nonatomic, assign) BOOL enableShadow;

#pragma mark UIView

- (SnSStackSubView*)stackview;
- (CGFloat)offsetShift;

@end
