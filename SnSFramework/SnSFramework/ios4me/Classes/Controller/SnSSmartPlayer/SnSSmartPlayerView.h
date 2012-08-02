//
//  SnSSmartPlayerView.h
//  RichMorningShow-iPad
//
//  Created by Julien Di Marco on 24/07/12.
//  Copyright (c) 2012 Smart&Soft. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AVPlayer;

@interface SnSSmartPlayerView : UIView
{
    AVPlayer    *player_;
}

@property (nonatomic, retain) AVPlayer *player;

- (void)setVideoFillMode:(NSString *)fillMode;

@end
