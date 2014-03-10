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

#import <SystemConfiguration/SCNetworkReachability.h>
#import <UIKit/UIKit.h>

@interface UIDevice (DeviceDetection)

+(int) deviceType;// 1 = iPhone, 2 = iPad
+(float) iOSVersion;// 2.0, 2.x, 3.x, 4.x
+(BOOL)isIPad;
+(BOOL)isIPhone;
+(BOOL)isIPhoneOS4;
+(BOOL)isRetinaDisplay;

- (NSString *) udid;

@end
