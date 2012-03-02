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