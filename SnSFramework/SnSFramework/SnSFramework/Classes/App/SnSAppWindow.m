//
//  SnSAppWindow.m
//  SnSFramework
//
//  Created by Johan Attali on 22/11/11.
//  Copyright (c) 2011 Smart&Soft. All rights reserved.
//

#import "SnSAppWindow.h"

@implementation SnSAppWindow

@synthesize eventDelegate = _eventDelegate;

- (void)sendEvent:(UIEvent *)event
{
    if ([_eventDelegate respondsToSelector:@selector(willSendEvent:)])
        [_eventDelegate willSendEvent:event];
    
    [super sendEvent:event];
    
    if ([_eventDelegate respondsToSelector:@selector(didSendEvent:)])
        [_eventDelegate didSendEvent:event];
    
    
}

@end
