//
//  UIScreen+Resolution.h
//  ios4me
//
//  Created by Matthias ROUBEROL on 08/11/12.
//  Copyright (c) 2012 Smart&Soft. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    UIScreenResolutionUnknown          = 0,
    UIScreenResolutioniPhoneStandard   = 1,    // iPhone 1,3,3GS Standard Display  (320x480px)
    UIScreenResolutioniPhoneRetina35   = 2,    // iPhone 4,4S Retina Display 3.5"  (640x960px)
    UIScreenResolutioniPhoneRetina4    = 3,    // iPhone 5 Retina Display 4"       (640x1136px)
    UIScreenResolutioniPadStandard     = 4,    // iPad 1,2 Standard Display        (1024x768px)
    UIScreenResolutioniPadRetina       = 5     // iPad 3 Retina Display            (2048x1536px)
}UIScreenResolution;


@interface UIScreen (Resolutions)

+ (UIScreenResolution)resolution;

@end
