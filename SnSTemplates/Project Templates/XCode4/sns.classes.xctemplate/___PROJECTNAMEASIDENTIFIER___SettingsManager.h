//
//  SettingsManager.h
//  Cobalink
//
//  Created by Smart&Soft Team on 03/06/2011.
//  Copyright 2011 Smart&Soft. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SETTINGS    ([___PROJECTNAMEASIDENTIFIER___SettingsManager instance])
// =====================  V1  ==========================================
// Set if is the first run
#define SETTING_IS_FIRSTRUN                     @"SETTING_IS_FIRSTRUN" // not used
#define SETTING_FIRSTRUN_TIMESTAMP              @"SETTING_FIRSTRUN_TIMESTAMP"
#define SETTING_LASTLAUNCH_TIMESTAMP            @"SETTING_LASTLAUNCH_TIMESTAMP"
#define SETTING_LASTRUN_DATE                    @"SETTING_LASTRUN_DATE"
#define SETTING_NB_LAUNCH_FROM_LAST_UPDATE      @"SETTING_NB_LAUNCH_FROM_LAST_UPDATE"
#define SETTING_NB_LAUNCH                       @"SETTING_NB_LAUNCH"
#define SETTING_RATING_PROPOSAL_TIMESTAMP       @"SETTING_RATING_PROPOSAL_TIMESTAMP"
#define SETTING_VERSION_LAST_UPDATE             @"SETTING_VERSION_LAST_UPDATE"

//--------------------- ADS --------------------------------------------
#define SETTING_HIDE_ADS                        @"SETTING_HIDE_ADS"

@interface ___PROJECTNAMEASIDENTIFIER___SettingsManager : SnSSingleton {
    
}

// Show ads
- (BOOL) isAdsHidden;
- (void) setAdsHidden:(BOOL)hidden;

@end
