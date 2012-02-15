//
//  SnSConstants.h
//  SnSFramework
//
//  Created by Johan Attali on 8/4/11.
//  Copyright 2011 Smart&Soft. All rights reserved.
//

/* Define here all the constants required by the framework */

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

#define SnSStackAnimationDuration	0.3f
#define SnSStackDefaultShift		185

#define SnSSQLiteAccessorFolderName @"SnSSQLite"
#define SnSConstantCacheFolderName @"Caches"