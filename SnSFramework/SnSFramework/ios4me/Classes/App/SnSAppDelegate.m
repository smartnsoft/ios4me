/* 
 * Copyright (C) 2009 Smart&Soft.
 * All rights reserved.
 *
 * The code hereby is the full property of Smart&Soft, SIREN 517 961 744.
 * http://www.smartnsoft.com - contact@smartnsoft.com
 * 
 * You are not allowed to use the source code or the resulting binary code, nor to modify the source code, without prior permission of the owner.
 */

//
//  SnSAppDelegate.m
//  SnSFramework
//
//  Created by Édouard Mercier on 14/12/2009.
//

#import "SnSAppDelegate.h"
#import "SnSAppWindow.h"

#import "SnSLog.h"
#import "SnSUtils.h"

(void) onExceptionHandler (NSException *exception);

#pragma mark -
#pragma mark SnSAppDelegate(Private)

/**
 * The private category is there for providing additional non public services.
 */
@interface SnSAppDelegate(Private)

- (void) listenToNotifications;
- (void) onLoadingActivity:(NSNotification *)notification;
- (void) handleLoadingActivity:(id)notification;

@end

#pragma mark -
#pragma mark SnSAppDelegate

@implementation SnSAppDelegate

@synthesize window;
@synthesize loadingView;

#pragma mark -
#pragma mark SnSAppDelegate(Private)

- (id<SnSExceptionHandler>) getExceptionHandler
{
	return nil;
}

- (id<SnSViewControllerInterceptor>) getInterceptor
{
	return nil;
}

- (id<SnSViewDecorator>) getDecorator
{
	return nil;
}

- (UIViewController *) getStartingViewController
{
	return nil;
}

#pragma mark -
#pragma mark UIApplicationDelegate

- (void) applicationDidFinishLaunching:(UIApplication *)application
{
	SnSLogClear();
	SnSLogLogo();
	
	SnSLogI(@"Application running with SnSFramework v1.0, copyright Smart&Soft");
	SnSLogI(@"Application starting on: %@ v%@", [[UIDevice currentDevice] systemName], [[UIDevice currentDevice] systemVersion]);
	SnSLogI(@"Application Documents path: %@", [SnSUtils applicationDocumentsPath]);
	SnSLogI(@"Application Caches path: %@", [SnSUtils applicationCachesPath]);
	
	// -----------------------------
	// Creating Exception Handler
	// -----------------------------
	id<SnSExceptionHandler> exceptionHandler = [self getExceptionHandler];
	if (exceptionHandler != nil)
	{
		SnSLogD(@"A specific exception handler for the application has been provided");
		[[SnSApplicationController instance] registerExceptionHandler:exceptionHandler];
	}
	
	// -----------------------------
	// Creating Interceptor
	// -----------------------------
	id<SnSViewControllerInterceptor> interceptor = [self getInterceptor];
	if (interceptor != nil)
	{
		SnSLogD(@"A specific interceptor for the application has been provided");
		[[SnSApplicationController instance] registerInterceptor:interceptor];
	}
	
	// -----------------------------
	// Creating Decorator
	// -----------------------------
	id<SnSViewDecorator> decorator = [self getDecorator];
	if (decorator != nil)
	{
		SnSLogD(@"A specific decorator for the application has been provided");
		[[SnSApplicationController instance] registerDecorator:decorator];
	}
	
	// -----------------------------
	// Creating Main Window
	// -----------------------------
	CGRect frame = [UIScreen mainScreen].bounds;
	SnSLogD(@"Creating a window with a frame set to %.0f x %.0f", frame.size.width, frame.size.height);
	
	window = [[[SnSAppWindow alloc] initWithFrame:frame] retain];
	
	// -----------------------------
	// Communicate with AppDelegate
	// -----------------------------
	@try
	{
		// We make sure that the exceptions are properly handled
		[self onApplicationDidFinishLaunchingBegin:application];
	}
	@catch (NSException * exception)
	{
		SnSLogEW(exception, @"A problem occurred at the beginning of the application initialization!");
		BOOL resume = YES;
		[[SnSApplicationController instance] handleException:self exception:exception resume:&resume];
	}
	
	// -----------------------------
	// Create Initial Controller
	// -----------------------------
	SnSLogI(@"Creating the starting view controller");
	
	UIViewController * viewController = [self getStartingViewController];
	
	[self.window addSubview:viewController.view];
	
	[self listenToNotifications];
	
	[self.window makeKeyAndVisible];
	
	@try
	{
		// We make sure that the exceptions are properly handled
		[self onApplicationDidFinishLaunchingEnd:application];
	}
	@catch (NSException * exception)
	{
		SnSLogEW(exception, @"A problem occurred at the end of the application initialization!");
		BOOL resume = YES;
		[[SnSApplicationController instance] handleException:self exception:exception resume:&resume];
	}
	
	NSSetUncaughtExceptionHandler (&onExceptionHandler);
}

- (void) applicationWillTerminate:(UIApplication *) application
{ 
	SnSLogI(@"Application stopping");
	[self.loadingView release];
}

- (void) applicationDidReceiveMemoryWarning:(UIApplication *)application
{
	SnSLogW(@"Receiving Memory Warning from: %@", [self class]);
}

#pragma mark -
#pragma mark NSObject

- (void) dealloc
{
	[[SnSApplicationController instance] release];
	[self.window release];
	[super dealloc];
}

#pragma mark -
#pragma mark SnSAppDelegate

NSString * LOADING_ACTION_NOTIFICATION_NAME = @"loadingActivity";
NSString * LOADING_ACTION_START = @"start";
NSString * LOADING_ACTION_MESSAGE = @"message";

- (void) onApplicationDidFinishLaunchingBegin:(UIApplication *)application
{
}

- (void) onApplicationDidFinishLaunchingEnd:(UIApplication *)application
{  
}

+ (void) startLoading:(id)sender withMessage:(NSString *)message
{  
	[[NSNotificationCenter defaultCenter] postNotificationName:LOADING_ACTION_NOTIFICATION_NAME 
														object:sender 
													  userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
																@"", LOADING_ACTION_START, 
																message, LOADING_ACTION_MESSAGE, nil]];
}

+ (void) stopLoading:(id)sender
{
	[[NSNotificationCenter defaultCenter] postNotificationName:LOADING_ACTION_NOTIFICATION_NAME object:sender userInfo:nil];
}

(void)onExceptionHandler (NSException *exception) // C Syntax
{
	NSArray *stack = [exception callStackReturnAddresses];
    SnSLogE(@"********************************\n****Stack trace:\n%@", stack);
}

#pragma mark -
#pragma mark SnSAppDelegate(Private)

- (void) listenToNotifications
{
	SnSLogD(@"Listening to notifications");
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(onLoadingActivity:) 
												 name:LOADING_ACTION_NOTIFICATION_NAME
											   object:nil];
}

/**
 * Performed in a new thread, in order to relief the caller.
 */
- (void) onLoadingActivity:(NSNotification *)notification
{
	SnSLogD(@"Received a 'loadingActivity' notification");
	[self performSelectorInBackgroundWithAutoreleasePool:@selector(handleLoadingActivity:) withObject:notification];
	
}

/**
 * When a loading action is in progress, the terminal network activity is displayed.
 * TODO: handle the message as well
 * TODO: count the number of times the "start" has been pushed
 */
- (void) handleLoadingActivity:(id)object
{
	NSNotification * notification = object;
	if (object == nil || [[notification name] isEqualToString:LOADING_ACTION_NOTIFICATION_NAME] == NO)
	{
		// We ignore notifications that are not expected or not well formed
		return;
	}
	@synchronized (self)
	{
		if (self.loadingView == nil)
		{
			// We create the loading view if not yet existing
			if ([self respondsToSelector:@selector(getCustomLoadingView)]) 
			{
				self.loadingView = [self performSelector:@selector(getCustomLoadingView)];
			}
			else 
			{
				self.loadingView = [[UIView alloc] initWithFrame:[self.window frame]];
				self.loadingView.hidden = YES;
				UIView * darkLayer = [[UIView alloc] initWithFrame:[self.window frame]];
				darkLayer.backgroundColor = [UIColor blackColor];
				darkLayer.alpha = 0.75;
				[self.loadingView addSubview:darkLayer];
				[darkLayer release];
				UIActivityIndicatorView * activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectZero];
				activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
				activityIndicatorView.tag = kTagActivityIndicatorLoadingView;
				[activityIndicatorView startAnimating];
				[self.loadingView addSubview:activityIndicatorView];
				[activityIndicatorView release];
			}
			[self.window addSubview:loadingView];
		}
	}
	// We relocate the progress indicator in the center
	//SnSLogD(@"The window is set with a frame set to %f x %f and with bounds set to %f x %f", self.window.frame.size.width, self.window.frame.size.height, self.window.bounds.size.width, self.window.bounds.size.height);
	CGFloat progressEdge = 50.0;
	CGFloat width, height;
	if ([UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationLandscapeLeft || [UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationLandscapeRight)
	{
		width = self.window.frame.size.height;
		height = self.window.frame.size.width;
	}
	else
	{
		width = self.window.frame.size.width;
		height = self.window.frame.size.height;
	}
	//SnSLogD(@"The actual window frame taking into account the UI orientation is set to %f x %f", width, height);
	//self.loadingView.frame = self.window.frame;
	CGFloat x = (width - progressEdge) / 2.0;
	CGFloat y = (height - progressEdge) / 2.0;
	UIActivityIndicatorView * activityIndicatorView = (UIActivityIndicatorView *) [self.loadingView viewWithTag:kTagActivityIndicatorLoadingView];
	if (activityIndicatorView != nil) 
	{
		activityIndicatorView.frame = self.window.frame;
		activityIndicatorView.bounds = CGRectMake(x, y, progressEdge, progressEdge);
	}
	if ([[notification userInfo] objectForKey:LOADING_ACTION_START] != nil)
	{
		[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
		self.loadingView.hidden = NO;
		[window bringSubviewToFront:loadingView];
	}
	else
	{
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
		self.loadingView.hidden = YES;
	}
}

@end
