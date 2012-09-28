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

//#import "GANTracker.h"
//#import "FlurryAPI.h"

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
	// Init Google Analytics tracker 
//	[[GANTracker sharedTracker] startTrackerWithAccountID:GA_UID
//										   dispatchPeriod:kGANDispatchPeriodSec
//												 delegate:nil];
	
	//  // Flurry Analytics Init 
	//  [FlurryAPI startSession:FLURRY_APPLICATION_KEY];
	
	// Cache init
	[SnSURLCache instance];
	
	
}

- (void) onApplicationDidFinishLaunchingEnd:(UIApplication *)application
{
	//  // Activate Location by Flurry if no already CLLocationManager
	//  [FlurryAPI startSessionWithLocationServices:FLURRY_APPLICATION_KEY];
	
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
	UIAlertView*  alertView = [[UIAlertView alloc] initWithTitle:SnSLocalized(@"ApplicationName") 
														 message:[exception reason]
														delegate:self 
											   cancelButtonTitle:NSLocalizedString(@"alertButton_OK", @"") 
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
	UIAlertView*  alertView = [[UIAlertView alloc] initWithTitle:SnSLocalized(@"ApplicationName") 
														 message:[exception reason]
														delegate:self 
											   cancelButtonTitle:NSLocalizedString(@"alertButton_OK", @"") 
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
		urlTracker = [NSString stringWithFormat:@"%@%@", urlTracker, [viewController performSelector:@selector(trackerInfos)]];
	
	return urlTracker;
}

- (void) onLifeCycleEvent:(UIViewController *)viewController onAggregate:(id<SnSViewControllerLifeCycle>)aggregate withEvent:(SnSInterceptorEvent)event
{
	if (aggregate == nil)
	{
		if (event == SnSInterceptorEventOnRetrieveDisplayObjects)
		{
			// Add some extra informations
			SnSLogD(@"Screen '%@' being loaded...", screenName);
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
#pragma mark UIApplicationDelegate

/**
 * Handle the url when system open the specific url scheme specify in Info.plist 
 */
- (BOOL) application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
	SnSLogD(@"url ouverte : %@", [url description]);
	
	UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:SnSLocalized(@"applicationName") 
														 message:[url description]
														delegate:self 
											   cancelButtonTitle:SnSLocalized(@"alertButton_OK") 
											   otherButtonTitles:nil];
	[alertView show];
	[alertView release];
	
	return YES;
}

/**
 * Update user information on server to sae the APNS token.
 **/
- (void) updateUserForNotification:(NSString *)token
{
	
}


- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken { 
	
	NSString *token = [NSString stringWithFormat:@"%@",deviceToken];
	SnSLogD(@"didRegisterForRemoteNotificationsWithDeviceToken", token);
	
	// Lancement de la mise à jour du token de l'utilisateur auprès de la plateforme de notification
	// en tache de fond pour ne pas bloquer l'interface graphique.
	[self performSelectorInBackgroundWithAutoreleasePool:@selector(updateUserForNotification:) withObject:token];
	
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err { 
	
	SnSLogI(@"Failed to register remote notifaction");
	SnSLogI([NSString stringWithFormat: @"Error: %@", err];); 
	
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
	
	SnSLogD(@"Did Receive Remote Notification");
	for (id key in userInfo) 
	{
		SnSLogD(@"key: %@, value: %@", key, [userInfo objectForKey:key]);
	}    
	
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
