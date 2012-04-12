//
//  ClockView.h
//  Test-SnSFramework
//
//  Created by Johan Attali on 12/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClockView : UIView
{
	UIView* viewHour_;
	UIView* viewMinute_;
}

@property (nonatomic, readonly) UIView* viewHour;
@property (nonatomic, readonly) UIView* viewMinute;
@end
