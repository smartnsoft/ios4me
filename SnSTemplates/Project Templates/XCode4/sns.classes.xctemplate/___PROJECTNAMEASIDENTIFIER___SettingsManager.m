//
//  SettingsManager.m
//  Cobalink
//
//  Created by Smart&Soft Team on 03/06/2011.
//  Copyright 2011 Smart&Soft. All rights reserved.
//

#import "___PROJECTNAMEASIDENTIFIER___SettingsManager.h"

@implementation ___PROJECTNAMEASIDENTIFIER___SettingsManager

#pragma mark -
#pragma mark Public API


// Show ads
- (BOOL) isAdsHidden
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:SETTING_HIDE_ADS];
}

- (void) setAdsHidden:(BOOL)hidden
{
    [[NSUserDefaults standardUserDefaults] setBool:hidden forKey:SETTING_HIDE_ADS];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark -
#pragma mark Singleton pattern

- (id) init {
	if((self = [super init]))
    {
		// Add some init if necessary
    }
	return self;
}


@end
