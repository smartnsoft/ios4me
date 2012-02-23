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
//  SnSViewController.m
//  SnSFramework
//
//  Created by Édouard Mercier on 18/12/2009.
//

#import "SnSViewController.h"

#import "SnSLog.h"
#import "SnSApplicationController.h"
#import "SnSViewControllerDelegate.h"

#import "SnSDelegate.h"
#import "NSObject+SnSExtension.h"


@implementation SnSViewController

@synthesize businessObject;
@synthesize context;
@synthesize responderRedirector;

#pragma mark -
#pragma mark NSObject
#pragma mark -

- (id) init
{
	self = [self initWithNibName:nil bundle:nil];
	
	return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
	{
		responderRedirector = [[SnSResponserRedirector alloc] initWith:self];
		businessObject = [[SnSWorkItem alloc] init];
		context = [[SnSWorkItem alloc] init];
		delegate = [[SnSViewControllerDelegate alloc] initWithAggregator:self aggregates:[self onRetrieveAggregates]];
	}
	
	return self;
}

/**
 * If a controller is being retained by a different thread other than the main thread,
 * releasing it from this thread will cause the application to crash with the message:
 * "Tried to obtain the web lock from a thread other than the main thread or the web thread"
 * so simply make sure the release method occurs on the main thread.
 * @link: http://stackoverflow.com/questions/945082/uiwebview-in-multithread-viewcontroller
 */
- (oneway void)release
{
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(release) withObject:nil waitUntilDone:NO];
    } else {
        [super release];
    }
}

- (void) dealloc
{
	[responderRedirector release]; 
	[delegate release];
	[businessObject release];
	[context release]; 
	
	[super dealloc];
}

#pragma mark -
#pragma mark SnSViewControllerAggregator
#pragma mark -

- (NSArray *) onRetrieveAggregates
{
	return nil; //[NSArray arrayWithObject:self];
}

#pragma mark -
#pragma mark SnSViewControllerLifeCycle
#pragma mark -

- (void) onRetrieveDisplayObjects:(UIView *)view
{
}

- (void) onRetrieveBusinessObjects
{
}

- (void) onFulfillDisplayObjects
{
}

- (void) onSynchronizeDisplayObjects
{
}

- (void) onDiscarded
{
	[businessObject release]; businessObject = nil;
	//[context release]; context = nil;
	//[responderRedirector release]; responderRedirector = nil;
}

#pragma mark -
#pragma mark UIViewController
#pragma mark -

- (void) loadView
{
	SnSLogD(@"%@", NSStringFromClass([self class]));
	[super loadView];
	[delegate loadView:self.view];
}

- (void) viewDidLoad
{
	SnSLogD(@"%@", NSStringFromClass([self class]));
	[super viewDidLoad];
	[delegate viewDidLoad];
}

- (void) viewDidUnload
{
	SnSLogD(@"%@", NSStringFromClass([self class]));
	[delegate viewDidUnload];
	[super viewDidUnload];
}

- (void) viewWillAppear:(BOOL)animated
{
	SnSLogD(@"%@", NSStringFromClass([self class]));
	[super viewWillAppear:animated];
	[delegate viewWillAppear:animated];
}

- (void) viewDidAppear:(BOOL)animated
{
	SnSLogD(@"%@", NSStringFromClass([self class]));
	[super viewDidAppear:animated];
	[delegate viewDidAppear:animated];
}

- (void) viewWillDisappear:(BOOL)animated
{
	SnSLogD(@"%@", NSStringFromClass([self class]));
	[delegate viewWillDisappear:animated];
	[super viewWillDisappear:animated];
}

- (void) viewDidDisappear:(BOOL)animated
{
	SnSLogD(@"%@", NSStringFromClass([self class]));
	[delegate viewDidDisappear:animated];
	[super viewDidDisappear:animated];
}

- (void) didReceiveMemoryWarning
{
	SnSLogW(@"%@", NSStringFromClass([self class]));
	[super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark SnSViewController
#pragma mark -

- (void) waitForSynchronizedDisplayObjects
{
	[delegate waitForSynchronizedDisplayObjects];
}

- (void) synchronizeDisplayObjects
{
	[delegate viewDidAppear:NO];
}

- (void) retrieveBusinessObjectsAndSynchronize
{
	[delegate viewDidLoad];
	[delegate viewWillAppear:NO];
	[delegate viewDidAppear:NO];
}

- (void) updateDisplayForOrientation:(UIInterfaceOrientation)iOrientation
{
	
}


@end
