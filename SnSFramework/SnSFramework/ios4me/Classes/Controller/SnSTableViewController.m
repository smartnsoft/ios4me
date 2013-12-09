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
//  SnSTableViewController.m
//  SnSFramework
//
//  Created by Édouard Mercier on 19/12/2009.
//

#import "SnSTableViewController.h"

#import "SnSLog.h"
#import "SnSDelegate.h"
#import "NSObject+SnSExtension.h"
#import "SnSApplicationController.h"

#pragma mark -
#pragma mark SnSTableViewController(Private)
#pragma mark -

@interface SnSTableViewController (Private)

@property(nonatomic, retain) id businessObjects;
@property(nonatomic, retain) id indexObjects;

@end

@implementation SnSTableViewController (Private)

- (id) businessObjects
{
	return businessObjects;
}

- (void)setBusinessObjects:(id)theBusinessObjects
{
	businessObjects = [theBusinessObjects retain];
}

- (id)indexObjects
{
	return indexObjects;
}

- (void)setIndexObjects:(id)theIndexObjects
{
	indexObjects = [theIndexObjects retain];
}

@end

#pragma mark -
#pragma mark SnSTableViewController
#pragma mark -

@implementation SnSTableViewController

@synthesize context;
@synthesize responderRedirector;

#pragma mark -
#pragma mark NSObject
#pragma mark -


- (id)init
{
	// initWithStyle: becomes the designated initalizer so we must call [self initWithStyle:]
	if ((self = [self initWithStyle:UITableViewStylePlain]))
	{
		responderRedirector = [[SnSResponserRedirector alloc] initWith:self];
		context = [[SnSWorkItem alloc] init];
	}
	
	
	return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
	if ((self = [super initWithStyle:style]))
	{
		responderRedirector = [[SnSResponserRedirector alloc] initWith:self];
		delegate = [[SnSViewControllerDelegate alloc] initWithAggregator:self aggregates:[self onRetrieveAggregates]];
		context = [[SnSWorkItem alloc] init];
	}
	
	return self;
}

- (void)dealloc
{
	[responderRedirector release];
	[delegate release];
	[context release]; 
	
	[super dealloc];
}

#pragma mark -
#pragma mark SnSViewControllerAggregator
#pragma mark -

- (NSArray *)onRetrieveAggregates
{
	return nil; //[NSArray arrayWithObject:self];
}

#pragma mark -
#pragma mark SnSViewControllerLifeCycle
#pragma mark -

- (void)onRetrieveDisplayObjects:(UIView *)view
{
}

- (void)onRetrieveBusinessObjects
{
	if ([self respondsToSelector:@selector(retrieveBusinessObjects)] == YES)
		self.businessObjects = [self retrieveBusinessObjects];
	
	if ([self respondsToSelector:@selector(retrieveIndexObjects)] == YES)
		self.indexObjects = [self retrieveIndexObjects];
}

- (void)onFulfillDisplayObjects
{
}

- (void)onSynchronizeDisplayObjects
{
	[self.tableView reloadData];
}

- (void)onDiscarded
{
	[self.businessObjects release]; businessObjects = nil;
}

#pragma mark -
#pragma mark SnSTableViewControllerBusinessObjects
#pragma mark -

- (void)synchronizeDisplay:(UITableViewCell *)cell withBusinessObject:(id)businessObject
{
}

#pragma mark -
#pragma mark UIViewController
#pragma mark -

/**
 *	Not sure this is a good idea from apple documentation
 *	
 */
- (void)loadView
{
	[super loadView];
	
	[delegate loadView:self.view];
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	[delegate viewDidLoad];
}

- (void)viewDidUnload
{
	[super viewDidUnload];
	
	[delegate viewDidUnload];

}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	[delegate viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
	[delegate viewDidAppear:animated];

	[super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[delegate viewWillDisappear:animated];
	
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[delegate viewDidDisappear:animated];
	
	[super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark UITableViewController
#pragma mark -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
	return self.businessObjects == nil ? 0 : [self.businessObjects count];
}

- (UITableViewCell *) tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	SnSLogD(@"tableView:%p cellForRowAtIndexPath:%@", aTableView, [indexPath description]);
	
	static NSString * cellIdentifier = @"cell";
	
	UITableViewCell * cell = [aTableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (cell == nil)
	{
		if ([self respondsToSelector:@selector(initCellWithIdentifier:andResponder:)] == YES)
		{
			cell = (UITableViewCell *)[self initCellWithIdentifier:cellIdentifier
													  andResponder:self.responderRedirector];
		}
		else 
		{
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		}
	} 	
	id businessObject;
	
	// only one section
	if ([self.businessObjects isKindOfClass:[NSArray class]]) 
		businessObject = [self.businessObjects objectAtIndex:indexPath.row];
	//more than one section1
	else 
	{
		if (indexObjects == nil) 
			businessObject = [[[(NSDictionary *)self.businessObjects allValues] objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
		else 
		{
			NSString * key = [self.indexObjects objectAtIndex:indexPath.section];
			SnSLogI(@"key = '%@'", key);
			businessObject = [[self.businessObjects objectForKey:key] objectAtIndex:indexPath.row];
		}
		
	}
	
	[self synchronizeDisplay:cell withBusinessObject:businessObject];
	
	return cell;
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	@try
	{
		[self tableViewCustom:aTableView didSelectRowAtIndexPath:indexPath];
	}
	@catch (NSException * exception)
	{
		BOOL resume;
		[[SnSApplicationController instance] handleException:self aggregate:nil exception:exception resume:&resume];
	}
}

- (void)tableView:(UITableView *)aTableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	@try
	{
		[self tableViewCustom:aTableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath];
	}
	@catch (NSException * exception)
	{
		BOOL resume;
		[[SnSApplicationController instance] handleException:self aggregate:nil exception:exception resume:&resume];
	}
}

#pragma mark -
#pragma mark SnSTableViewController
#pragma mark -

- (void)waitForSynchronizedDisplayObjects
{
	[delegate waitForSynchronizedDisplayObjects];
}

- (void)synchronizeDisplayObjects
{
	[delegate viewDidAppear:NO];
}

- (void)retrieveBusinessObjectsAndSynchronize
{
	[delegate viewDidLoad];
	[delegate viewDidAppear:NO];
}

- (void) tableViewCustom:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (void) tableViewCustom:(UITableView *)aTableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	// rendering of TableCell by UIViewDecorator
	[[SnSApplicationController instance] renderViewTableCell:cell];
}

@end
