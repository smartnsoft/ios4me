//
//  SnSFramework
//  
//
//  Created by Matthias ROUBEROL on 21/04/10.
//  Copyright 2010 Smart&Soft. All rights reserved.
//

#import <SystemConfiguration/SCNetworkReachability.h>

//add SystemConfiguration Framework

@interface UIDevice (DeviceConnectivity)

+(BOOL)cellularConnected; 
+(BOOL)wiFiConnected;
+(BOOL)networkConnected;   

@end
