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

#import "AboutViewController.h"

#define viewWidth self.view.frame.size.width
#define viewHeight self.view.frame.size.height

#pragma mark -
#pragma mark AboutViewController

@implementation AboutViewController

@synthesize content;
@synthesize aboutContent;
@synthesize activity;

- (void) updateIpadDisplay
{
	
}

- (void) updateIphoneDisplay
{

}

- (void) updateDisplay
{
#ifdef __IPHONE_3_2
	if (IS_RUNNING_ON_IPAD)
	{
		[self updateIpadDisplay];
	}
	else
#endif
	{
		[self updateIphoneDisplay];
	}
	
}

- (void) onClose:(id)sender
{
	[self dismissModalViewControllerAnimated:YES];	
}

#pragma mark -
#pragma mark SnSViewControllerLifeCycle

- (void) onRetrieveDisplayObjects:(UIView *)view
{
  [super onRetrieveDisplayObjects:view];

#ifdef __IPHONE_3_2
	if (IS_RUNNING_ON_IPAD)
  {
		
  }
#endif
	
  self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[SnSImageUtils imageNamed:@"background_allpages"]];
	
  // Right bar button to close 
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self.responderRedirector action:@selector(onClose:)];
  
	// content of About
	self.aboutContent = [[UIWebView alloc] initWithFrame:CGRectMake(0,0,screenWidth, screenHeight-navigationBarHeight)];
  self.aboutContent.delegate = self;
	self.aboutContent.backgroundColor = [UIColor clearColor];
	self.aboutContent.opaque = NO;
  //self.aboutContent.scalesPageToFit = YES;
  self.aboutContent.contentMode = UIViewContentModeScaleAspectFit;
  self.aboutContent.dataDetectorTypes = UIDataDetectorTypeAll;
  self.aboutContent.autoresizingMask = UIViewAutoresizingFlexibleWidth;
  [self.view addSubview:aboutContent];
  
  self.activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
  self.activity.center = CGPointMake(screenWidth/2, screenHeight/2);
  [self.view addSubview:self.activity];
  [self.activity startAnimating];
  
}

- (void) onRetrieveBusinessObjects
{
	[super onRetrieveBusinessObjects];
	NSError * erreur;
  self.content = [[NSString alloc] initWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"",CREDITS_URL_PREFIX,@"about_iphone.html"]] 
                                                                     encoding:NSUTF8StringEncoding 
                                                                        error:&erreur];
  if (erreur != nil || self.content == nil) 
  {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"about_iphone" ofType:@"html"];
		NSFileHandle *readHandle = [NSFileHandle fileHandleForReadingAtPath:path];
    
		self.content = [[NSString alloc] initWithData: 
                            [readHandle readDataToEndOfFile] encoding:NSUTF8StringEncoding];
    NSString *pathBaseUrl = [[NSBundle mainBundle] bundlePath];
    baseURL = [NSURL fileURLWithPath:pathBaseUrl];
  }
  else 
  {
    baseURL = [NSURL URLWithString:CREDITS_URL_PREFIX];
  }

  
}

- (void) onFulfillDisplayObjects
{
  [super onFulfillDisplayObjects];
  
  
  [self.aboutContent loadHTMLString:self.content baseURL:baseURL];
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
#pragma mark UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
  [self.activity stopAnimating];
  self.activity.hidden = YES;
}


#pragma mark -
#pragma mark UIViewController

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
	//[super didReceiveMemoryWarning];
	
	SnSLogE(@"didReceiveMemoryWarning in class : %@", [self class]);
}


@end
