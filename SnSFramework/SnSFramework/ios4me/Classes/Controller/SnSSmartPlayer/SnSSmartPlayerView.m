//
//  SnSSmartPlayerView.m
//  RichMorningShow-iPad
//
//  Created by Julien Di Marco on 24/07/12.
//  Copyright (c) 2012 Smart&Soft. All rights reserved.
//

#import "SnSSmartPlayerView.h"

#import <AVFoundation/AVFoundation.h>

@implementation SnSSmartPlayerView

@synthesize player = player_;

+ (Class)layerClass
{
    return [AVPlayerLayer class];
}

# pragma mark -
# pragma mark Getters / Setters
# pragma mark -

# pragma mark getters

- (AVPlayer*)player
{
    return ((AVPlayerLayer *)self.layer).player;
}

# pragma mark setters

- (void)setPlayer:(AVPlayer *)player
{
    if (player_ != player)
    {
        ((AVPlayerLayer *)self.layer).player = player;
        [player_ release];
        player_ = [player retain];
    }
}

# pragma mark -
# pragma mark Others
# pragma mark -

// Specifies how the video is displayed within a player layer’s bounds. 
// (AVLayerVideoGravityResizeAspect is default)
- (void)setVideoFillMode:(NSString *)fillMode
{
	AVPlayerLayer *playerLayer = (AVPlayerLayer*)self.layer;
	playerLayer.videoGravity = fillMode;
}

# pragma mark -
# pragma mark Basics
# pragma mark -

- (void)dealloc
{	
	[super dealloc];
    
    self.player = nil;
}

@end
