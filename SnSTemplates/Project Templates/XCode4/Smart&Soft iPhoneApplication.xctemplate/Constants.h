/* 
 * Copyright (C) 2009-2010 Smart&Soft.
 * All rights reserved.
 *
 * The code hereby is the full property of Smart&Soft, SIREN 517 961 744.
 * http://www.smartnsoft.com - contact@smartnsoft.com
 * 
 * You are not allowed to use the source code or the resulting binary code, nor to modify the source code, without prior permission of the owner.
 */

//
//  Constants.h
//  ___PROJECTNAMEASIDENTIFIER___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright ___YEAR___ ___ORGANIZATIONNAME___. All rights reserved.
//


#import <Foundation/Foundation.h>

#import "___PROJECTNAMEASIDENTIFIER___AppDelegate.h"

#define ValueDeviceDepend(ipad,iphone) (([UIDevice isIPad]==YES)?ipad:iphone)
#define ValueiPhoneRetina4Depend(retina4,retina3) (([UIScreen resolution] == UIScreenResolutioniPhoneRetina4)?retina4:retina3)

/** Fixed size **/
#define standardScreenWidth 320
#define standardScreenHeight 480
#define standardResolution 163 // in dpi
#define statusBarHeight 20
#define navigationBarHeight 44
#define keyboardHeight 216
#define tabBarHeight 49
#define switchWidth 94
#define standardSliderHeight 30

#define APP_DELEGATE ((___PROJECTNAMEASIDENTIFIER___AppDelegate *) [[UIApplication sharedApplication] delegate])

#define IS_RUNNING_ON_IPAD UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad

#define COLOR_FFFFFF COLOR_HEXA(@"#FFFFFF")
#define COLOR_333333 COLOR_HEXA(@"#333333")
#define COLOR_666666 COLOR_HEXA(@"#666666")
#define COLOR_CCCCCC COLOR_HEXA(@"#CCCCCC")
#define COLOR_999999 COLOR_HEXA(@"#999999")
#define COLOR_000000 COLOR_HEXA(@"#000000")

#define SnSViewX(v)			((v).frame.origin.x)
#define SnSViewY(v)			((v).frame.origin.y)
#define SnSViewW(v)			((v).frame.size.width)
#define SnSViewH(v)			((v).frame.size.height)

#define kSnSScreenWidth			[[UIScreen mainScreen] applicationFrame].size.width
#define kSnSScreenHeight		[[UIScreen mainScreen] applicationFrame].size.height
#define kSnSCurrentOrientation 	[[UIApplication sharedApplication] statusBarOrientation]

#define SnSLocalized(s) NSLocalizedString(s,@"")

#define DeviceOrientationSupported(orientation) 	UIDeviceOrientationIsPortrait(orientation) 
#define NavigationBarTintColor 						RGB(182, 16, 127)

/********************************** TRACKING ANALYTICS ********************************/
extern NSString * const PREFIX_TRACKING;



extern NSString * const CREDITS_URL_PREFIX;

extern const NSTimeInterval DOWNLOAD_TIMEOUT_IN_SECOND;
