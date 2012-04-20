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
//  AutomationViewController.m
//  Automation
//
//  Created by Johan Attali on «DATE».
//  Copyright 2012 Smart&Soft. All rights reserved.
//  Created by ApplicationAuthor on ApplicationCreationDate.
//

#import "WebViewController.h"


#define viewWidth self.view.frame.size.width
#define viewHeight self.view.frame.size.height

@implementation WebViewController

@synthesize url;
@synthesize webView;
@synthesize activity;

#pragma mark -
#pragma mark WebViewController


#pragma mark -
#pragma mark SnSViewControllerLifeCycle

- (void) onRetrieveDisplayObjects:(UIView *)view
{
	[super onRetrieveDisplayObjects:view];
	
	// -----------------------------
	// Setup Webview
	// -----------------------------
	webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
	webView.delegate = self;
	webView.dataDetectorTypes = UIDataDetectorTypeNone;
	webView.scalesPageToFit = YES;
	webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	webView.backgroundColor = [UIColor whiteColor];
	
	
	// -----------------------------
	// Setup activity indicator
	// -----------------------------
	activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	activity.center = CGPointMake(screenWidth/2, screenHeight/2);
	[activity startAnimating];
	
	// -----------------------------
	// Add subviews
	// -----------------------------
	[self.view addSubview:webView];
	[self.view addSubview:activity];
}

- (void) onRetrieveBusinessObjects
{
	[super onRetrieveBusinessObjects];
	
	NSString * urlString = [self.context containerForKey:@"url"];
	
	self.url = [NSURL URLWithString:urlString];
	
}

- (void) onFulfillDisplayObjects
{
	[super onFulfillDisplayObjects];
	
	[self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];
	
}

- (void) onSynchronizeDisplayObjects
{
	[super onSynchronizeDisplayObjects];
	
}

- (void) onDiscarded
{
	[super onDiscarded];
}

#pragma mark -
#pragma mark SnSViewControllerExceptionHandler

/*
 
 - (BOOL) onBusinessObjectException:(id<SnSViewControllerLifeCycle>)aggregate exception:(SnSBusinessObjectException *)exception resume:(BOOL *)resume;
 - (BOOL) onLifeCycleException:(id<SnSViewControllerLifeCycle>)aggregate exception:(SnSLifeCycleException *)exception resume:(BOOL *)resume;
 - (BOOL) onOtherException:(id<SnSViewControllerLifeCycle>)aggregate exception:(NSException *)exception resume:(BOOL *)resume;
 
 */


#pragma mark -
#pragma mark UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	[self.activity stopAnimating];
	self.activity.hidden = YES;
}

#pragma mark -
#pragma mark UIViewController

- (void) dealloc
{
	[webView release];
	[activity release];
	[url release];
	
	[super dealloc];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
	return UIDeviceOrientationIsPortrait(interfaceOrientation);
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	SnSLogD(@"willRotateToInterfaceOrientation");
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	//[self synchronizeDisplayObjects];
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	
	SnSLogE(@"didReceiveMemoryWarning in class : %@", [self class]);
}


@end
