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
//  ___FILENAME___
//  ___PROJECTNAMEASIDENTIFIER___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright ___YEAR___ ___ORGANIZATIONNAME___. All rights reserved.
//

«OPTIONALHEADERIMPORTLINE»

@implementation «FILEBASENAMEASIDENTIFIER»

#pragma mark -
#pragma mark SnSViewControllerLifeCycle

- (void) onRetrieveDisplayObjects:(UIView *)view
{
	[super onRetrieveDisplayObjects:view];
	
	// -----------------------------
	// Add Tableview
	// -----------------------------
	tableView_ = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SnSViewW(self.view), SnSViewH(self.view)-45-20)
											  style:UITableViewStylePlain];

	tableView_.delegate = self;
	tableView_.dataSource = self;

	[self.view addSubview:tableView_];	
}

- (void) onRetrieveBusinessObjects
{
	[super onRetrieveBusinessObjects];
	
}

- (void) onFulfillDisplayObjects
{
	[super onFulfillDisplayObjects];
	
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
#pragma mark UITableViewDelegate
#pragma mark -

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	Class cellClass 		= [UITableViewCell class];
	NSString* identifier 	= NSStringFromClass(cellClass);
	UITableViewCell* cell 	= [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
	 												  reuseIdentifier:identifier] autorelease];
//	 UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	
	// Create cell if needed
	if (cell == nil)
	{
		// Create owner
		UITableViewCell* xibCell = [[[cellClass alloc] init] autorelease];
		
		// load cell from xib
		NSArray* objects = [[NSBundle mainBundle] loadNibNamed:@"XIBCellName" owner:xibCell options:nil];
		
		// assign first object to identified cell
		cell = [objects objectAtIndex:0];
	}
		
	// Configure cell
	cell.textLabel.text = @"Not Yet Configured";
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	
}


#pragma mark -
#pragma mark UITableViewDataSource
#pragma mark -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return arc4random()%30+1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}


#pragma mark -
#pragma mark UIViewController
#pragma mark -

#pragma mark Basics

- (void)dealloc
{
	SnSReleaseAndNil(tableView_);
	
	[super dealloc];
}

- (void)didReceiveMemoryWarning
{
	SnSLogW(@"");
	
	[super didReceiveMemoryWarning];
	
}

#pragma mark Rotation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
	return DeviceOrientationSupported(interfaceOrientation);
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	SnSLogD(@"");
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	SnSLogD(@"");
}

@end
