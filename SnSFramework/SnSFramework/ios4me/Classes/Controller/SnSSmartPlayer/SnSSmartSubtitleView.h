//
//  SnSSmartSubtitleView.h
//  RichMorningShow-iPad
//
//  Created by Julien Di Marco on 24/07/12.
//  Copyright (c) 2012 Smart&Soft. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AVPlayerItem;

@interface SnSSmartSubtitleView : UILabel
{
    AVPlayerItem    *playerItem_;
}

@property (nonatomic, retain) AVPlayerItem *playerItem;

@end
