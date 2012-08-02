//
//  AVPlayerItem+SnSSmartPlayer.m
//  RichMorningShow-iPad
//
//  Created by Julien Di Marco on 31/07/12.
//  Copyright (c) 2012 Smart&Soft. All rights reserved.
//

#import "AVPlayerItem+SnSSmartPlayer.h"

@implementation AVPlayerItem (SnSSmartPlayer)

- (CMTime)duration
{
    return self.asset.duration;
}

@end
