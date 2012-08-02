//
//  SnSSmartSubtitleView.m
//  RichMorningShow-iPad
//
//  Created by Julien Di Marco on 24/07/12.
//  Copyright (c) 2012 Smart&Soft. All rights reserved.
//

#import "SnSSmartSubtitleView.h"

#import <AVFoundation/AVFoundation.h>

@implementation SnSSmartSubtitleView

@synthesize playerItem = playerItem_;

+ (Class)layerClass
{
    return [AVSynchronizedLayer class];
}

# pragma mark -
# pragma mark Getters / Setters
# pragma mark -

# pragma mark getters

- (AVPlayerItem*)playerItem
{
    return ((AVSynchronizedLayer *)self.layer).playerItem;
}

# pragma mark setters

- (void)setPlayerItem:(AVPlayerItem *)playerItem
{
    if (playerItem_ != playerItem)
    {
        ((AVSynchronizedLayer *)self.layer).playerItem = playerItem;
        [playerItem_ release];
        playerItem_ = [playerItem retain];
    }
}

# pragma mark -
# pragma mark Basics
# pragma mark -

- (void)dealloc
{	
	[super dealloc];
    
    self.playerItem = nil;
}

@end
