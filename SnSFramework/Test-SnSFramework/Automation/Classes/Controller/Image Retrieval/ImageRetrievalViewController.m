//
//  ImageRetrievalViewController.m
//  Test-SnSFramework
//
//  Created by Johan Attali on 04/05/12.
//  Copyright 2012 Smart&Soft. All rights reserved.
//

#import "ImageRetrievalViewController.h"
#import "ImageRetrievallCellView.h"

// Services
#import "AutomationServices.h"
#import <ASIHTTPFramework/ASIHTTPFramework.h>


#define VIEW_X(v)			((v).frame.origin.x)
#define VIEW_Y(v)			((v).frame.origin.y)
#define VIEW_WIDTH(v)		((v).frame.size.width)
#define VIEW_HEIGHT(v)		((v).frame.size.height)

@implementation ImageRetrievalViewController
@synthesize businessObjects = businessObjects_;


#pragma mark -
#pragma mark ImageRetrievalViewController
#pragma mark -

- (void) updateDisplay
{
	
}

#pragma mark -
#pragma mark SnSViewControllerLifeCycle
#pragma mark -

- (void)viewWillAppear:(BOOL)animated
{
	SnSLogD(@"");
}

/**
 * Called after the loadView call
 */
- (void) onRetrieveDisplayObjects:(UIView *)view
{
	[super onRetrieveDisplayObjects:view];
	
	UITableView* aTableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 0, VIEW_WIDTH(self.view), VIEW_HEIGHT(self.view)-45)
															style:UITableViewStylePlain] autorelease];
	
	aTableView.delegate = self;
	aTableView.dataSource = self;
	
	[self.view addSubview:aTableView];
	
}

/**
 * Called after the viewDidLoad call
 */
- (void) onRetrieveBusinessObjects
{	
	[super onRetrieveBusinessObjects];
	
	NSMutableArray* aImages = [NSMutableArray array];
	
	NSString* aSize = @"m";
	
	[aImages addObject:[NSString stringWithFormat:@"http://farm2.staticflickr.com/1155/4727683919_d50d77f7cb_%@.jpg", aSize]];
	[aImages addObject:[NSString stringWithFormat:@"http://farm2.staticflickr.com/1427/4727689491_5dab7d93fc_%@.jpg", aSize]];
	[aImages addObject:[NSString stringWithFormat:@"http://farm2.staticflickr.com/1231/4728331342_da11bfc238_%@.jpg", aSize]];
	[aImages addObject:[NSString stringWithFormat:@"http://farm5.staticflickr.com/4119/4910978481_589c8f1b87_%@.jpg", aSize]];
	[aImages addObject:[NSString stringWithFormat:@"http://farm5.staticflickr.com/4125/5072557215_0b8c68cfcb_%@.jpg", aSize]];
	[aImages addObject:[NSString stringWithFormat:@"http://farm5.staticflickr.com/4152/5073149500_cd425316aa_%@.jpg", aSize]];
	[aImages addObject:[NSString stringWithFormat:@"http://farm5.staticflickr.com/4113/5073159476_e3e4a8012d_%@.jpg", aSize]];
	[aImages addObject:[NSString stringWithFormat:@"http://farm6.staticflickr.com/5087/5321317959_e76841ae53_%@.jpg", aSize]];
	[aImages addObject:[NSString stringWithFormat:@"http://farm6.staticflickr.com/5203/5321321061_8845e19c24_%@.jpg", aSize]];
	[aImages addObject:[NSString stringWithFormat:@"http://farm6.staticflickr.com/5167/5381267025_c01bc0d3fe_%@.jpg", aSize]];
	
	[aImages addObject:[NSString stringWithFormat:@"http://farm5.staticflickr.com/4048/4467720913_cb6a0fecff_%@.jpg", aSize]];
	[aImages addObject:[NSString stringWithFormat:@"http://farm5.staticflickr.com/4022/4471250376_d5cd943477_%@.jpg", aSize]];
	[aImages addObject:[NSString stringWithFormat:@"http://farm5.staticflickr.com/4032/4493543468_4fbcf27391_%@.jpg", aSize]];
	[aImages addObject:[NSString stringWithFormat:@"http://farm3.staticflickr.com/2748/4493554730_e7c80f29aa_%@.jpg", aSize]];
	[aImages addObject:[NSString stringWithFormat:@"http://farm3.staticflickr.com/2720/4500588753_ab38a362c8_%@.jpg", aSize]];
	[aImages addObject:[NSString stringWithFormat:@"http://farm5.staticflickr.com/4069/4500590293_541c3c54bc_%@.jpg", aSize]];
	[aImages addObject:[NSString stringWithFormat:@"http://farm3.staticflickr.com/2692/4503240831_432e6573ea_%@.jpg", aSize]];
	[aImages addObject:[NSString stringWithFormat:@"http://farm5.staticflickr.com/4007/4531147845_91e9c74c5c_%@.jpg", aSize]];
	[aImages addObject:[NSString stringWithFormat:@"http://farm5.staticflickr.com/4033/4531151295_dd7223568e_%@.jpg", aSize]];
	[aImages addObject:[NSString stringWithFormat:@"http://farm3.staticflickr.com/2678/4531769174_610a1c74cd_%@.jpg", aSize]];
	[aImages addObject:[NSString stringWithFormat:@"http://farm5.staticflickr.com/4066/4531776154_5a3e66a31c_%@.jpg", aSize]];
	[aImages addObject:[NSString stringWithFormat:@"http://farm5.staticflickr.com/4064/4545877381_c2a2ea2c31_%@.jpg", aSize]];
	[aImages addObject:[NSString stringWithFormat:@"http://farm5.staticflickr.com/4015/4592681210_0c893b5254_%@.jpg", aSize]];
	[aImages addObject:[NSString stringWithFormat:@"http://farm4.staticflickr.com/3543/4604601562_7083a174d2_%@.jpg", aSize]];
	[aImages addObject:[NSString stringWithFormat:@"http://farm2.staticflickr.com/1176/4605070844_ab8c484ea4_%@.jpg", aSize]];
	[aImages addObject:[NSString stringWithFormat:@"http://farm5.staticflickr.com/4036/4669466359_3f8abefc75_%@.jpg", aSize]];
	[aImages addObject:[NSString stringWithFormat:@"http://farm2.staticflickr.com/1295/4679651173_d9c48e798e_%@.jpg", aSize]];
	[aImages addObject:[NSString stringWithFormat:@"http://farm5.staticflickr.com/4018/4680292604_4f35c9dccd_%@.jpg", aSize]];


	
	self.businessObjects = [NSArray arrayWithArray:aImages];
	
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

- (void)viewWillDisappear:(BOOL)animated
{
	[[ASIDownloadCache sharedCache] clearCachedResponsesForStoragePolicy:ASICacheForSessionDurationCacheStoragePolicy];
	[[SnSMemoryCache instance] purgeAll];
}

/**
 * Called after the viewDidUnload call
 */
- (void) onDiscarded
{
	[super onDiscarded];
}

#pragma mark -
#pragma mark UITableViewDataSource
#pragma mark -


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	ImageRetrievallCellView* aCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
		
	if (aCell == nil)
		aCell = [[[ImageRetrievallCellView alloc] initWithStyle:UITableViewCellStyleDefault
												reuseIdentifier:NSStringFromClass([self class])] autorelease];
	else
		SnSLogD(@"Reusing cell: %p", aCell);
	
	NSString* aURLStr = [businessObjects_ objectAtIndex:indexPath.row];
	
	[aCell loadWithBusinessObject:aURLStr];
	

	return aCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return kImageRetrievalCellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [businessObjects_ count];
}

#pragma mark -
#pragma mark UITableViewDelegate
#pragma mark -

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	
}


#pragma mark -
#pragma mark UIViewController
#pragma mark -

- (void)dealloc
{
	self.businessObjects = nil;
	
	[super dealloc];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
	return DeviceOrientationSupported(interfaceOrientation);
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	SnSLogD(@"");
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	SnSLogD(@"");
}

- (void)didReceiveMemoryWarning
{
	SnSLogW(@"");

	[super didReceiveMemoryWarning];
	
}


@end
