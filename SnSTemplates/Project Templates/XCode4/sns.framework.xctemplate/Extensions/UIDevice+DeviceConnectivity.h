//
//  RMCSportServices.m
//  RMCSport
//
//  Created by Matthias ROUBEROL on 21/04/10.
//  Copyright 2010 Haploid. All rights reserved.
//
#import <SystemConfiguration/SCNetworkReachability.h>

//add SystemConfiguration Framework

@interface UIDevice (DeviceConnectivity)

+(BOOL)cellularConnected; 
+(BOOL)wiFiConnected;
+(BOOL)networkConnected;   

@end
