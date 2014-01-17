/* 
 * Copyright (C) 2009-2010 Smart&Soft.
 * All rights reserved.
 *
 * The code hereby is the full property of Smart&Soft, SIREN 517 961 744.
 * http://www.smartnsoft.com - contact@smartnsoft.com
 * 
 * You are not allowed to use the source code or the resulting binary code, nor to modify the source code, without prior permission of the owner.
 */

//
//  ___PROJECTNAMEASIDENTIFIER___AppDelegate.m
//  ___PROJECTNAMEASIDENTIFIER___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright ___YEAR___ ___ORGANIZATIONNAME___. All rights reserved.
//

#import "___PROJECTNAMEASIDENTIFIER___AppDelegate.h"
#import "___PROJECTNAMEASIDENTIFIER___ViewController.h"

#import <ios4me-ext-smartad/SmartAdManager.h>
#import <ios4me-ext-smartcommand/SnSCapptainReachDataPushReceiver.h>

#import "CPPushMessage.h"
#import "MemoryCPDefaultNotifier.h"

#pragma mark -
#pragma mark ___PROJECTNAMEASIDENTIFIER___AppDelegate(Private)

@interface ___PROJECTNAMEASIDENTIFIER___AppDelegate(Private)

@end

#pragma mark -
#pragma mark ___PROJECTNAMEASIDENTIFIER___AppDelegate

// Dispatch period in seconds for Google Analytics tracking
static const NSInteger kGANDispatchPeriodSec = 10;

@implementation ___PROJECTNAMEASIDENTIFIER___AppDelegate

#pragma mark -
#pragma mark SnSAppDelegate

- (id<SnSExceptionHandler>) getExceptionHandler
{
	return self;
}

- (id<SnSViewControllerInterceptor>) getInterceptor
{
	return self;
}

- (id<SnSViewDecorator>) getDecorator
{
	return self;
}

/**
 * Should return the inital view controller loaded by the framework
 * @return The starting view controller
 */
- (UIViewController *) getStartingViewController
{
	UIViewController * viewController = [[___PROJECTNAMEASIDENTIFIER___ViewController alloc] init];
	UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController:viewController];
	navController.navigationBar.barStyle = UIBarStyleBlackOpaque;
	navController.navigationBar.tintColor = NavigationBarTintColor;
	return navController;
}

- (void) onApplicationDidFinishLaunchingBegin:(UIApplication *)application
{
	SnSLogI(@"=========================================== Capptain init : %@",[NSDate date]);
    // Capptain init
#ifdef DEBUG
    // To obtai IDFA [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString]
	[CapptainAgent setTestLogEnabled:YES];
    NSString * deviceId = [[CapptainAgent shared] deviceId];
#endif
    CPReachModule* reach = [CPReachModule moduleWithNotificationIcon:[SnSImageUtils imageNamed:@"Icon"]];
    [reach setDataPushDelegate:self];
    [reach registerNotifier:[[___PROJECTNAMEASIDENTIFIER___CPDefaultNotifier alloc] init] forCategory:kCPReachDefaultCategory];
    [CapptainAgent registerApp:CAPPTAIN_APPLICATION_ID identifiedBy:CAPPTAIN_SDK_KEY modules:reach, nil];
    [[CapptainAgent shared] setPushDelegate:self];
    SnSLogI(@"=========================================== Capptain init : END %@ deviceId %@",[NSDate date], deviceId);
    
}

- (void) onApplicationDidFinishLaunchingEnd:(UIApplication *)application
{
	SnSLogI(@"Application did finish launching");    

	// Register push notification
	[[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
	
	// Remove old badges
	[UIApplication sharedApplication].applicationIconBadgeNumber = 0;
	
}

#pragma mark -
#pragma mark SnSExceptionHandler

- (BOOL) onException:(id)sender exception:(NSException *)exception resume:(BOOL *)ioResume
{
	UIAlertView*  alertView = [[UIAlertView alloc] initWithTitle:SnSLocalized(@"application.name")
														 message:[exception reason]
														delegate:self 
											   cancelButtonTitle:NSLocalizedString(@"button.ok", @"") 
											   otherButtonTitles:nil];
	
	[alertView show];
	[alertView release];
	*ioResume = NO;
	return YES;
}

- (BOOL) onBusinessObjectException:(UIViewController *)viewController 
						 aggregate:(id<SnSViewControllerLifeCycle>)aggregate 
						 exception:(SnSBusinessObjectException *)exception 
							resume:(BOOL *)resume
{
	return NO;
}

- (BOOL) onLifeCycleException:(UIViewController *)viewController 
					aggregate:(id<SnSViewControllerLifeCycle>)aggregate 
					exception:(SnSLifeCycleException *)exception
					   resume:(BOOL *)resume
{
	return NO;
}

- (BOOL) onOtherException:(UIViewController *)viewController 
				aggregate:(id<SnSViewControllerLifeCycle>)aggregate 
				exception:(NSException *)exception 
				   resume:(BOOL *)ioResume
{
	UIAlertView*  alertView = [[UIAlertView alloc] initWithTitle:SnSLocalized(@"application.name")
														 message:[exception reason]
														delegate:self 
											   cancelButtonTitle:NSLocalizedString(@"button.ok", @"") 
											   otherButtonTitles:nil];
	
	[alertView show];
	[alertView release];
	*ioResume = NO;
	return YES;
}

#pragma mark -
#pragma mark SnSViewControllerInterceptor

- (NSString *) computeUrlForTracker:(NSString *)screenName andController:(UIViewController *)viewController
{
	NSString *urlTracker = [NSString stringWithFormat:PREFIX_TRACKING, screenName];
	
	if ([viewController respondsToSelector:@selector(trackerInfos)]) 
	{
		urlTracker = [NSString stringWithFormat:@"%@%@", urlTracker, [viewController performSelector:@selector(trackerInfos)]];
	}
	return urlTracker;
}

- (void) onLifeCycleEvent:(UIViewController *)viewController onAggregate:(id<SnSViewControllerLifeCycle>)aggregate withEvent:(SnSInterceptorEvent)event
{
	if (aggregate == nil)
	{
		NSString * screenName = [[viewController class] description];
		screenName = [screenName substringToIndex:[[screenName lowercaseString] rangeOfString:@"viewcontroller"].location];
        if (event == SnSInterceptorEventOnRetrieveDisplayObjects)
		{
			// Add some extra informations
			SnSLogD(@"Screen '%@' being loaded...", screenName);
            // Capptain Tracking
            NSString * activityName = screenName;
            if ([viewController respondsToSelector:@selector(capptainActivityName)])
            {
                activityName = [viewController performSelector:@selector(capptainActivityName)];
            }
            NSDictionary * activityExtra = nil;
            if ([viewController respondsToSelector:@selector(capptainActivityExtra)])
            {
                activityExtra = [viewController performSelector:@selector(capptainActivityExtra)];
            }
            if (activityName != nil)
            {
                [[CapptainAgent shared] startActivity:activityName extras:activityExtra];
            }
		}
		else if (event == SnSInterceptorEventOnSynchronizeDisplayObjects)
        { SnSLogD(@"Screen '%@' being redisplayed...", screenName); }
		else if (event == SnSInterceptorEventOnFulfillDisplayObjects)
        { SnSLogD(@"Screen '%@' being displayed...", screenName); }
		else if (event == SnSInterceptorEventOnDiscarded)
        { SnSLogD(@"Screen '%@' being discarded...", screenName); }
	}
}

#pragma mark -
#pragma mark SnSViewDecorator

- (void) renderView:(UIViewController *)viewController onAggregate:(id<SnSViewControllerLifeCycle>)aggregate
{
	SnSLogD(@"%@::renderView viewController:%@", [self class], [viewController class]);
	if (aggregate == nil)
	{
		SnSLogD(@"Beginning of rendering view of viewController view = %@", viewController.view);
	}
}

- (void) renderViewTableCell:(UITableViewCell *)viewCell
{
	SnSLogD(@"%@::renderViewTableCell viewCell:%@, viewCell.backgroundColor : %@", [self class], viewCell, viewCell.backgroundColor);
}

#pragma mark -
#pragma mark Capptain - CPReachDataPushDelegate
#pragma mark -

/*!
 * This function is called when a datapush of type text has been received.
 * @param body your content.
 **/
-(BOOL)onDataPushStringReceived:(NSString*)body
{
    if ([body rangeOfString:@"class"].location != NSNotFound)
    {
        [[SnSCapptainReachDataPushReceiver instance] onUseDataPushString:body];
    }
    else
    {
        SnSLogD(@"String data push message received: %@", body);
    }
    
    return YES;
}

/*!
 * This function is called when a datapush of type base64 has been received.
 * @param decodedBody your base64 content decoded.
 * @param encodedBody your content still encoded in base64.
 **/
-(BOOL)onDataPushBase64ReceivedWithDecodedBody:(NSData*)decodedBody andEncodedBody:(NSString*)encodedBody
{
    SnSLogD(@"Base64 data push message received: %@", encodedBody);
    // Do something useful with decodedBody like updating an image view
    return YES;
}


#pragma mark -
#pragma mark Capptain - CPPushDelegate
#pragma mark -


/*!
 * Sent when a message from another device has been received.
 * @param payload Message payload.
 * @param deviceId Device identifier who sent the message.
 */
-(void)didReceiveMessage:(NSString*)payload fromDevice:(NSString*)deviceId
{
    
}

#pragma mark Messages coming from the Capptain Push Service

/*!
 * Sent when a push message is received by the Capptain Push Service.
 */
-(void)didReceiveMessage:(CPPushMessage*)message
{
    NSString* myPayload = message.payload;
    SnSLogI(@"didReceiveMessage : payload:%@",myPayload);
    
}

/*!
 * Sent when capptain is about to retrieve the push message that launched the application (from an apple push notification).
 * It is a good opportunity to start displaying a message to the end user indicating that data is being loaded.
 */
-(void)willRetrieveLaunchMessage
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

/*!
 * Sent when capptain failed to retrieve the push message that launched the application.
 * Use this opportunity to hide any loading message and to display a dialog to the end user
 * indicating that the message could not be fetched.
 */
-(void)didFailToRetrieveLaunchMessage
{
    /* Hide network activity indicator */
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
}

/*!
 * Sent when capptain received the push message that launched the application.
 * Use this opportunity to to hide any loading message and display appropriate content to the end user.
 * Note that the launchMessage attribute can be nil if you're not the recipient of this message.
 */
-(void)didReceiveLaunchMessage:(CPPushMessage *)launchMessage
{
    /* Hide network activity indicator */
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}


#pragma mark -
#pragma mark UIApplicationDelegate
- (void)handlePushParameters:(NSDictionary*)iParams
{
	NSString * credits = nil;
    for (id key in iParams)
    {
        // récupération de l'identifiant article
        if ([key isEqualToString:@"credits"])
            credits = (NSString *)[iParams objectForKey:key];
    }
    // Add credits to user for example....
    
}

- (BOOL) handleURL:(NSURL *)url
{
    NSString * stringUrl = [url absoluteString];
    if ([stringUrl hasPrefix:@"fb"])
    {
        //return [[FacebookServices instance] handleOpenURL:url];
    }
	else if ([stringUrl hasPrefix:CAPPTAIN_APPLICATION_ID])
    {
		NSDictionary* aParameters = [NSDictionary dictionaryWithFormEncodedString:[url query]];
		
		[self handlePushParameters:aParameters];
    }
    
    return NO;
}

/**
 * Handle the url when system open the specific url scheme specify in Info.plist
 */
- (BOOL) application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [self handleURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [self handleURL:url];
}


/**
 * Update user information on server to sae the APNS token.
 **/
- (void) updateUserForNotification:(NSData *)token
{
	[[CapptainAgent shared] registerDeviceToken:token];
}


- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
	
	SnSLogD(@"didRegisterForRemoteNotificationsWithDeviceToken", deviceToken);
	
	// Lancement de la mise à jour du token de l'utilisateur auprès de la plateforme de notification
	// en tache de fond pour ne pas bloquer l'interface graphique.
	[self performSelectorInBackgroundWithAutoreleasePool:@selector(updateUserForNotification:) withObject:deviceToken];
	
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
	
	SnSLogI(@"Failed to register remote notifaction");
	SnSLogI(([NSString stringWithFormat: @"Error: %@", err]));
	
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
	
	// Capptain
    [[CapptainAgent shared] applicationDidReceiveRemoteNotification:userInfo];
    
    SnSLogD(@"Did Receive Remote Notification");
	for (id key in userInfo)
	{
		SnSLogD(@"key: %@, value: %@", key, [userInfo objectForKey:key]);
	}
	
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Ad managers invalidates
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    // Count of lauches
    NSNumber * nbLauches = [SETTINGS readSetting:SETTING_NB_LAUNCH];
    if (nbLauches == nil)
    {
        nbLauches = [NSNumber numberWithInt:1];
    }
    else
    {
        nbLauches = [NSNumber numberWithInt:([nbLauches intValue]+1)];
    }
    [SETTINGS saveSetting:nbLauches forKey:SETTING_NB_LAUNCH];
    
    // Count of Launches from last update
    NSNumber * nbLauchesFromLastUpdate = [SETTINGS readSetting:SETTING_NB_LAUNCH_FROM_LAST_UPDATE];
    if (nbLauchesFromLastUpdate == nil)
    {
        nbLauchesFromLastUpdate = [NSNumber numberWithInt:1];
    }
    else
    {
        nbLauchesFromLastUpdate = [NSNumber numberWithInt:([nbLauchesFromLastUpdate intValue]+1)];
    }
    [SETTINGS saveSetting:nbLauchesFromLastUpdate forKey:SETTING_NB_LAUNCH_FROM_LAST_UPDATE];
    
}

/**
 * Application is "closed" by user. In fact the application go to sleep.
 */
- (void)applicationDidEnterBackground:(UIApplication *)application
{
	
}

/**
 * Fired when the application wake up
 **/
- (void)applicationWillEnterForeground:(UIApplication *)application
{
	//on met à zero les badges
	[UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
}

@end
