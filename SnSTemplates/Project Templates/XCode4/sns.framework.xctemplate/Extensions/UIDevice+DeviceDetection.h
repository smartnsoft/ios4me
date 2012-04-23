//
//  RMCSportServices.m
//  RMCSport
//
//  Created by Matthias ROUBEROL on 21/04/10.
//  Copyright 2010 Haploid. All rights reserved.
//
#import <SystemConfiguration/SCNetworkReachability.h>


@interface UIDevice (DeviceDetection)

+(int) deviceType;// 1 = iPhone, 2 = iPad
+(float) iOSVersion;// 2.0, 2.x, 3.x, 4.x
+(BOOL)isIPad;
+(BOOL)isIPhone;
+(BOOL)isIPhoneOS4;

@end
