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
//  SnSTableViewRefreshController.m
//  SnSFramework
//
//  Created by «FULLUSERNAME» on «DATE».
//  Copyright «YEAR» «ORGANIZATIONNAME». All rights reserved.
//

#import "SnSTableViewRefreshController.h"

#import <QuartzCore/QuartzCore.h>

#pragma mark -
#pragma mark SnSTableViewRefreshController

@implementation SnSTableViewRefreshController

#pragma mark -
#pragma mark SnSTableViewRefreshController
#pragma mark -

- (void)reloadTableViewDataSource
{
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	_reloading = YES;
    [self retrieveBusinessObjectsAndSynchronize];
}

- (void)doneLoadingTableViewData
{
	//  model should call this when its done loading
    _reloading = NO;
	[refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
	
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods
#pragma mark -

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
	//[self reloadTableViewDataSource];
    [self performSelectorInBackgroundWithAutoreleasePool:@selector(reloadTableViewDataSource)];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
	return _reloading; // should return if data source model is reloading	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view
{
	return [NSDate date]; // should return date data source was last changed	
}


#pragma mark -
#pragma mark SnSViewControllerLifeCycle
#pragma mark -

- (void) onRetrieveDisplayObjects:(UIView *)view
{
    [super onRetrieveDisplayObjects:view];
    
	if (refreshHeaderView == nil) {
		
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
		view.delegate = self;
		[self.tableView addSubview:view];
		refreshHeaderView = view;
		[view release];
		
	}
	
	//  update the last update date
	[refreshHeaderView refreshLastUpdatedDate];
}


- (void) onSynchronizeDisplayObjects
{
    [self performSelectorOnMainThread:@selector(doneLoadingTableViewData) withObject:nil waitUntilDone:NO];
}

- (void) onDiscarded
{
    [refreshHeaderView release]; refreshHeaderView = nil;
    
    [super onDiscarded];
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods
#pragma mark -

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
	
	[refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
	
}

#pragma mark -
#pragma mark NSObject
#pragma mark -

- (void) dealloc
{
    [super dealloc];
}



@end
