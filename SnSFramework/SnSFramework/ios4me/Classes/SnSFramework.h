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
//  Created by Édouard Mercier on 11/12/2009.
//

/**
 * @mainpage SnSFramework: an Objective-C iPhone framework.
 *
 * The purpose of this framework is to speed-up iPhone applications development...
 */

#import <Foundation/Foundation.h> 

// We import all the framework header files

// Constants
#import "SnSConstants.h"

// Application
#import "SnSAppWindow.h"
#import "SnSAppDelegate.h"
#import "SnSDelegate.h"
#import "SnSCacheDelegate.h"

// Cache
#import "SnSAbstractCache.h"
#import "SnSMemoryCache.h"
#import "SnSURLCache.h"

// Connection
#import "SnSURLConnection.h"

// Controllers
#import "SnSLifeCycle.h"
#import "SnSViewControllerDelegate.h"
#import "SnSViewController.h"
#import "SnSTableViewController.h"
#import "SnSTableViewRefreshController.h"
#import "SnSFormViewController.h"

// StackView Controllers
#import "SnSStackView.h"
#import "SnSStackViewController.h"
#import "SnSStackSubViewController.h"
#import "SnSStackTableSubViewController.h"

// Extension 
#import "NSObject+SnSExtension.h"
#import "UIKit+SnSExtension.h"
#import "NSString+SnSExtension.h"
#import "UIDevice+DeviceDetection.h"
#import "UIDevice+DeviceConnectivity.h"

// Exceptions
#import "SnSExceptionHandler.h"

// SQLite 
#import "SnSSQLiteStorable.h"
#import "SnSSQLiteAccessor.h"

// Log
#import "SnSLog.h"

// Services
#import "SnSWebServiceCaller.h"
#import "SnSStoreManager.h"


// Errors/Exceptions
#import "SnSCacheException.h"

// Utils
#import "SnSUtils.h"
#import "SnSImageDownloader.h"

#define SNS_FRAMEWORK_VERSION @"1.0"

/**
 * Provides information about the SnSFramework.
 */
@interface SnSFramework : NSObject
{
}

/**
 * @return the version name of the hereby framework
 */
+ (NSString *) version;

@end
