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

/* Define here all the constants required by the framework */

//////////////////////////////////////////////////////////////////////////////////////

#pragma mark -
#pragma mark Macros
#pragma mark -

/*!
 * You pass an NSObject* in parameter and it will be released
 * and set to nil at the same time
 * @param o	an NSObject* instance. It can be already set to nil.
 *			in which case, the macro has no effect.
 */
#define SnSReleaseAndNil(o) if ((o)) { [(o) release]; o = nil; } 

/*! 
 * You pass a length in pixels in portrait mode and in landscape mode and 
 * depending on the current device orientation will return the portrait length or
 * the landscape length given in parameters\
 * @param p	The length in pixels in portrait mode
 * @param l The length in pixels in landscape mode
 * @return either p or l depending on the device orientation
 */
#define SnSOrientationDepend(p,l) ( SnSOrientationDependWithOrientation([[UIApplication sharedApplication] statusBarOrientation], (p) , (l) ) )
#define SnSOrientationDependWithOrientation(o,p,l) ( UIDeviceOrientationIsValidInterfaceOrientation(o) ? (UIDeviceOrientationIsPortrait(o) ? (p) : (l)) : 0 )

#define SnSStrechButton(b,x,y) ([b setBackgroundImage:[[b backgroundImageForState:UIControlStateNormal] stretchableImageWithLeftCapWidth:x topCapHeight:y] \
                                             forState:UIControlStateNormal])

//////////////////////////////////////////////////////////////////////////////////////

#pragma mark -
#pragma mark SnSScrollFollower
#pragma mark -

#define SnSScollFollowerDefaultSize CGSizeMake(80,90)
#define SnSScollFollowerDefaultIndicatorLength 9
#define SnSScollFollowerDefaultAnimationOffset 60;

//////////////////////////////////////////////////////////////////////////////////////

#pragma mark -
#pragma mark SnSStackView
#pragma mark -


#define SnSStackAnimationDuration	0.3f
#define SnSStackDefaultShift		185

//////////////////////////////////////////////////////////////////////////////////////


#pragma mark -
#pragma mark Caches
#pragma mark -


#define SnSCacheDefaultHighCapacity 1024*1024*3 // 3 mb
#define SnSCacheDefaultLowCapacity	1024*300	// 300 kb
#define SnSCacheCheckerMaxCaches	10			// Maximum number of caches handle
#define SnSCacheCheckerRefreshTime	60			// Refresh every minute
#define SnSCacheFolderName			@"Caches"

//////////////////////////////////////////////////////////////////////////////////////

#pragma mark -
#pragma mark SQLite
#pragma mark -

#define SnSSQLiteAccessorFolderName @"SnSSQLite"

#pragma mark - Back Compatibility -

#ifdef __IPHONE_6_0 // iOS6 and later
#   define UITextAlignmentCenter    NSTextAlignmentCenter
#   define UITextAlignmentLeft      NSTextAlignmentLeft
#   define UITextAlignmentRight     NSTextAlignmentRight
#   define UILineBreakModeTailTruncation     NSLineBreakByTruncatingTail
#   define UILineBreakModeMiddleTruncation   NSLineBreakByTruncatingMiddle
#endif
