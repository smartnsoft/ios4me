/*
 * (C) Copyright 2009-2011 Smart&Soft SAS (http://www.smartnsoft.com/) and contributors.
 *
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the GNU Lesser General Public License
 * (LGPL) version 3.0 which accompanies this distribution, and is available at
 * http://www.gnu.org/licenses/lgpl.html
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * Lesser General Public License for more details.
 *
 * Contributors:
 *     Smart&Soft - initial API and implementation
 */

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
#import "SnSCacheChecker.h"
#import "SnSCacheDelegate.h"
#import "SnSCacheItem.h"

// Connection
#import "SnSURLConnection.h"

// Controllers
#import "SnSLifeCycle.h"
#import "SnSViewControllerDelegate.h"
#import "SnSViewController.h"
#import "SnSTableViewController.h"
#import "SnSTableViewRefreshController.h"
#import "SnSFormViewController.h"
#import "SnSScrollFollower.h"

// SnSSmartPlayer
#import "SnSSmartPlayerController.h"
#import "SnSSmartPlayerView.h"
#import "SnSSmartSubtitleView.h"

// StackView Controllers
#import "SnSStackView.h"
#import "SnSStackViewController.h"
#import "SnSStackSubViewController.h"
#import "SnSStackTableSubViewController.h"

// Extension 
#import "NSObject+SnSExtension.h"
#import "UIKit+SnSExtension.h"
#import "NSString+SnSExtension.h"
#import "NSDate+SnSExtension.h"
#import "UIDevice+DeviceDetection.h"
#import "UIDevice+DeviceConnectivity.h"
#import "NSArray+SnSExtension.h"
#import "UIView+SnSExtension.h"
#import "UILabel+SnSExtension.h"
#import "NSData+SnSExtension.h"
#import "UIImage+SnSExtension.h"
#import "NSDictionary+SnSExtension.h"
#import "UIScreen+Resolutions.h"

// Exceptions
#import "SnSExceptionHandler.h"

// SQLite 
#import "SnSSQLiteStorable.h"
#import "SnSSQLiteAccessor.h"

// Log
#import "SnSLog.h"

// Services
#import "SnSRemoteServices.h"
#import "SnSWebServiceCaller.h"
#import "SnSStoreManager.h"
#import "SnSStoreObserver.h"

// Utils
#import "SnSUtils.h"
#import "SnSImageDownloader.h"

// UI Views
#import "SnSLoadingView.h"
#import "SnSDropListView.h"
#import "SnSDropListViewCell.h"
#import "SnSScrollFollowerView.h"

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
