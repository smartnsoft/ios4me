//
//  SnSFramework
//  
//
//  Created by Matthias ROUBEROL on 21/04/10.
//  Copyright 2010 Smart&Soft. All rights reserved.
//

#import "UIDevice+DeviceConnectivity.h"

#define EXTERNAL_HOST @"google.com"

@implementation UIDevice (DeviceConnectivity)

+(BOOL)cellularConnected{// EDGE or GPRS
  SCNetworkReachabilityFlags    flags = 0;
  SCNetworkReachabilityRef      netReachability = NULL;
  
  netReachability     = SCNetworkReachabilityCreateWithName(CFAllocatorGetDefault(), [EXTERNAL_HOST UTF8String]);
  if(netReachability){
    SCNetworkReachabilityGetFlags(netReachability, &flags);
    CFRelease(netReachability);
  }
  if(flags & kSCNetworkReachabilityFlagsIsWWAN){
    return YES;
  }
  return NO;
}

+(BOOL)wiFiConnected{
  if([self cellularConnected]){
    return NO;
  }
  return [self networkConnected];
}

+(BOOL)networkConnected{
  SCNetworkReachabilityFlags     flags = 0;
  SCNetworkReachabilityRef       netReachability = NULL;
  BOOL                           retrievedFlags = NO;
  
  netReachability     = SCNetworkReachabilityCreateWithName(CFAllocatorGetDefault(), [EXTERNAL_HOST UTF8String]);
  if(netReachability){
    retrievedFlags      = SCNetworkReachabilityGetFlags(netReachability, &flags);
    CFRelease(netReachability);
  }
  if (!retrievedFlags || !flags){
    return NO;
  }
  return YES;
}

@end
