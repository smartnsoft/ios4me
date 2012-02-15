//
//  SnSFramework
//  
//
//  Created by Matthias ROUBEROL on 21/04/10.
//  Copyright 2010 Smart&Soft. All rights reserved.
//

// DEVICE DETECTION BASE ON http://blog.onstreamtv.de/?p=489

#import "UIDevice+DeviceDetection.h"

#define EXTERNAL_HOST @"google.com"

@implementation UIDevice (DeviceDetection)

+(int) deviceType
{
	if ([self isIPad]) 
	{
		return 2;
	}
	else 
	{
		return 1;
	}

}

+(float) iOSVersion
{
	NSString* ver = [[UIDevice currentDevice] systemVersion];
	
	/* I assume that the default iOS version will be 3.0 */
	float version = 3.0;
	if ([ver length] >= 3)
	{
		/*
		 # The version string has the format major.minor.revision (eg. "3.1.3").
		 # I am not interested in the revision part of the version string, so I can do this.
		 # It will return the float value for "3.1", because substringToIndex is called first.
		 #
		 */
		version = [[ver substringToIndex:3] floatValue];
	}
	return version;
}

+(BOOL)isIPad
{
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
	{
		return YES;
	}
	else 
	{
		return NO;
	}
}

+(BOOL)isIPhone
{
	return ![self isIPad];
}

+(BOOL)isIPhoneOS4
{
	return ([self iOSVersion] >= 4.0);
}

+(BOOL)isRetinaDisplay
{
  return ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2);  
}

- (NSString *) udid
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"CUSTOM_DEVICE_UDID"] == nil ) 
    {
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringUnique] forKey:@"CUSTOM_DEVICE_UDID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"CUSTOM_DEVICE_UDID"];
    
}

@end
