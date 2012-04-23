/* 
 * Copyright (C) 2009 Smart&Soft.
 * All rights reserved.
 *
 * The code hereby is the full property of Smart&Soft, SIREN 517 961 744.
 * http://www.smartnsoft.com - contact@smartnsoft.com
 * 
 * You are not allowed to use the source code or the resulting binary code, nor to modify the source code, without prior permission of the owner.
 *
 * This library is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 */

//
//  SnSFramework.h
//  SnSFramework
//
//  Created by ƒdouard Mercier on 11/12/2009.
//

/**
 * @mainpage SnSFramework: an Objective-C iPhone framework.
 *
 * The purpose of this framework is to speed-up iPhone applications development...
 */

#import <Foundation/Foundation.h> 

// We import all the framework header files
#import "SnSAppDelegate.h"

#import "SnSMemoryCache.h"
#import "SnSURLCache.h"

#import "SnSLifeCycle.h"
#import "SnSViewController.h"
#import "SnSTableViewController.h"
#import "SnSFormViewController.h"

#import "NSObject+SnSExtension.h"
#import "UIKit+SnSExtension.h"
#import "UIDevice+DeviceDetection.h"
#import "UIDevice+DeviceConnectivity.h"

#import "SnSLog.h"

#import "SnSWebServiceCaller.h"

#import "SnSUtils.h"
#import "SnSDelegate.h"
#import "SnSImageDownloader.h"

/**
 * Provides information about the SnSFramework.
 */
@interface SnSFramework : NSObject
{
}

/**
 * @return the version name of the hereby framework
 */
+ (NSString *) getVersion;

@end
