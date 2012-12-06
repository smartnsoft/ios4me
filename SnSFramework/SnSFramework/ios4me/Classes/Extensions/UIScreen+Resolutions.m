//
//  UIScreen+Resolution.m
//  ios4me
//
//  Created by Matthias ROUBEROL on 08/11/12.
//  Copyright (c) 2012 Smart&Soft. All rights reserved.
//

#import "UIScreen+Resolutions.h"

@implementation UIScreen (Resolutions)

+ (UIScreenResolution)resolution
{
    UIScreenResolution resolution = UIScreenResolutionUnknown;
    UIScreen *mainScreen = [UIScreen mainScreen];
    CGFloat scale = ([mainScreen respondsToSelector:@selector(scale)] ? mainScreen.scale : 1.0f);
    CGFloat pixelHeight = (CGRectGetHeight(mainScreen.bounds) * scale);
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        if (scale == 2.0f) {
            if (pixelHeight == 960.0f)
                resolution = UIScreenResolutioniPhoneRetina35;
            else if (pixelHeight == 1136.0f)
                resolution = UIScreenResolutioniPhoneRetina4;
            
        } else if (scale == 1.0f && pixelHeight == 480.0f)
            resolution = UIScreenResolutioniPhoneStandard;
        
    } else {
        if (scale == 2.0f && pixelHeight == 2048.0f) {
            resolution = UIScreenResolutioniPadRetina;
            
        } else if (scale == 1.0f && pixelHeight == 1024.0f) {
            resolution = UIScreenResolutioniPadStandard;
        }
    }
    
    return resolution;
}


@end
