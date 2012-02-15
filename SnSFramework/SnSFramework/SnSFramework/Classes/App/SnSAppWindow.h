//
//  SnSAppWindow.h
//  SnSFramework
//
//  Created by Johan Attali on 22/11/11.
//  Copyright (c) 2011 Smart&Soft. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark -
#pragma mark SnSAppWindowDelegate
#pragma mark -

@protocol SnSAppWindowDelegate <NSObject>

@optional

- (void)willSendEvent:(UIEvent*)iEvent;
- (void)didSendEvent:(UIEvent*)iEvent;

@end

#pragma mark -
#pragma mark SnSAppWindow
#pragma mark -

@interface SnSAppWindow : UIWindow
{
	id<SnSAppWindowDelegate> _eventDelegate;
}

@property (nonatomic, assign) id<SnSAppWindowDelegate> eventDelegate;

@end
