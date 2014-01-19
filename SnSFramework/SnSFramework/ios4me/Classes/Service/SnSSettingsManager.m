//
//  SettingsManager.m
//  Cobalink
//
//  Created by Smart&Soft Team on 03/06/2011.
//  Copyright 2011 Smart&Soft. All rights reserved.
//

#import "SnSSettingsManager.h"

@implementation SnSSettingsManager

#pragma mark -
#pragma mark Public API

- (void) saveSetting:(id)value forKey:(NSString*)key
{
	[[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (id) readSetting:(NSString*)key
{
	return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

- (void) deleteSetting:(NSString*)key
{
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) saveIntSetting:(int)value forKey:(NSString*)key
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:value] forKey:key];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (int) readIntSetting:(NSString*)key defaulValue:(int)defaultValue
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:key] == nil)
    {
        [self saveIntSetting:defaultValue forKey:key];
    }
	return [[[NSUserDefaults standardUserDefaults] objectForKey:key] intValue];
}

- (void) saveBoolSetting:(BOOL)value forKey:(NSString*)key
{
	[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:value] forKey:key];
	[[NSUserDefaults standardUserDefaults] synchronize];
        
}

- (BOOL) readBoolSetting:(NSString*)key defaulValue:(BOOL)defaultValue
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:key] == nil)
    {
        [self saveBoolSetting:defaultValue forKey:key];
    }
	return [[[NSUserDefaults standardUserDefaults] objectForKey:key] boolValue];
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
