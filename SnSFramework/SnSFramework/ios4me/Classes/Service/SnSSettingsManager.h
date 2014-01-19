//
//  SettingsManager.h
//  Cobalink
//
//  Created by Smart&Soft Team on 03/06/2011.
//  Copyright 2011 Smart&Soft. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SnSSingleton.h"

@interface SnSSettingsManager : SnSSingleton {
    
}

- (void) saveSetting:(id)value forKey:(NSString*)key;
- (id) readSetting:(NSString*)key;
- (void) deleteSetting:(NSString*)key;

- (void) saveIntSetting:(int)value forKey:(NSString*)key;
- (int) readIntSetting:(NSString*)key defaulValue:(int)defaultValue;

- (void) saveBoolSetting:(BOOL)value forKey:(NSString*)key;
- (BOOL) readBoolSetting:(NSString*)key defaulValue:(BOOL)defaultValue;


@end
