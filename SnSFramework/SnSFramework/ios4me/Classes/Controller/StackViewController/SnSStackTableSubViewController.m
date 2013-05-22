//
//  SnSStackTableSubViewController.m
//  SnSFramework
//
//  Created by Johan Attali on 04/05/12.
//  Copyright 2012 Smart&Soft. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

// Controllers
#import "SnSStackTableSubViewController.h"
#import "SnSStackSubViewController.h"
#import "SnSStackViewController.h"

// Views
#import "SnSStackView.h"
#import "SnSLog.h"

#define VIEW_X(v)			((v).frame.origin.x)
#define VIEW_Y(v)			((v).frame.origin.y)
#define VIEW_WIDTH(v)		((v).frame.size.width)
#define VIEW_HEIGHT(v)		([(v) frame].size.height)

@implementation SnSStackTableSubViewController

@synthesize tableView = _tableView;

#pragma mark -
#pragma mark SnSStackTableSubViewController
#pragma mark -

- (void) updateDisplay
{
	
}

#pragma mark -
#pragma mark SnSViewControllerLifeCycle
#pragma mark -

/**
 * Called after the loadView call
 */
- (void) onRetrieveDisplayObjects:(UIView *)view
{
	[super onRetrieveDisplayObjects:view];
	
	self.stackview.frame = CGRectMake(0, 0, 400, VIEW_HEIGHT(_stackController.view));
	self.stackview.layer.borderColor = [UIColor lightGrayColor].CGColor;
	self.stackview.layer.borderWidth = 1.f;
	
	if (!_tableView)
	{
		_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, VIEW_WIDTH(self.view), VIEW_HEIGHT(self.view))];
		_tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
		_tableView.contentMode = UIViewContentModeTopLeft;
		[self.view addSubview:_tableView];
	}
	
	if (CGRectIsEmpty(_tableView.frame))
		_tableView.frame = CGRectMake(0, 0, VIEW_WIDTH(self.view), VIEW_HEIGHT(self.view));
	
	if (!_tableView.delegate)
		_tableView.delegate = self;
	
	if (!_tableView.dataSource)
		_tableView.dataSource = self;	
	
	
}

/**
 * Called after the viewDidLoad call
 */
- (void) onRetrieveBusinessObjects
{	
	[super onRetrieveBusinessObjects];
	
}

/**
 * Called after the viewWillAppear call
 */
- (void) onFulfillDisplayObjects
{
	[super onFulfillDisplayObjects];
	
}

/**
 * Called after the viewDidAppear call
 */
- (void) onSynchronizeDisplayObjects
{
	[super onSynchronizeDisplayObjects];
	
}

/**
 * Called after the viewDidUnload call
 */
- (void) onDiscarded
{
	[super onDiscarded];
}

#pragma mark -
#pragma mark UIViewController
#pragma mark -

#pragma mark Basics

- (void)dealloc
{
	self.tableView = nil;
	
	[super dealloc];
}

- (void)didReceiveMemoryWarning
{
	SnSLogW(@"");
	
	[super didReceiveMemoryWarning];	
}

#pragma mark Rotations

//- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
//{
//}
//
//- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
//{
//    
//}


#pragma mark -
#pragma mark UITableViewDataSource
#pragma mark -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return (NSInteger)(rand()%15);
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	
    
    // Configure the cell...
	cell.textLabel.text = [NSString stringWithFormat:@"Data %d", indexPath.row];
	cell.textLabel.textColor = [UIColor blackColor];
	
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate
#pragma mark -

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	// Call designated initalizer
	SnSStackTableSubViewController* aController = [[SnSStackTableSubViewController alloc] initWithNibName:nil bundle:nil];
//	aController.stackview.frame = CGRectMake(0, 0, 400, VIEW_HEIGHT(self.view));
//	aController.stackview.layer.borderColor = [UIColor lightGrayColor].CGColor;
//	aController.stackview.layer.borderWidth = 1.f;
	
	aController.stackController				= _stackController;
	
	[_stackController pushStackController:aController fromController:self animated:YES];
}


@end
