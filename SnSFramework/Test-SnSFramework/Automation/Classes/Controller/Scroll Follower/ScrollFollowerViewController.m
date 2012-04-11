/*
 * (C) Copyright 2009-2011 Smart&Soft SAS (http://www.smartnsoft.com/) and contributors.
 *
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the GNU Lesser General Public License
 * (LGPL) version 3.0 which accompanies this distribution, and is available at
 * http://www.gnu.org/licenses/lgpl.html
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * Lesser General Public License for more details.
 *
 * Contributors:
 *     Smart&Soft - initial API and implementation
 * Creator:
 *     Johan Attali
 */

#import "ScrollFollowerViewController.h"
#import "ScrollFollowerViewCell.h"
#import "ScrollFollowerRemoteServices.h"

#define VIEW_X(v)			((v).frame.origin.x)
#define VIEW_Y(v)			((v).frame.origin.y)
#define VIEW_WIDTH(v)		((v).frame.size.width)
#define VIEW_HEIGHT(v)		((v).frame.size.height)

@implementation ScrollFollowerViewController
@synthesize tableView = tableView_;
@synthesize scrollFollower = scrollFollower_;

#pragma mark -
#pragma mark ScrollFollowerViewController
#pragma mark -

static NSString *randomWords[] = {
	@"Hello",
	@"World",
	@"Some",
	@"Random",
	@"Words",
	@"Blarg",
	@"Poop",
	@"Something",
	@"Zoom zoom",
	@"Beeeep",
};

static NSString *randomImgs[] = {
	@"http://farm2.staticflickr.com/1155/4727683919_d50d77f7cb_%@.jpg",
	@"http://farm2.staticflickr.com/1427/4727689491_5dab7d93fc_%@.jpg",
	@"http://farm2.staticflickr.com/1231/4728331342_da11bfc238_%@.jpg",
	@"http://farm5.staticflickr.com/4119/4910978481_589c8f1b87_%@.jpg",
	@"http://farm5.staticflickr.com/4125/5072557215_0b8c68cfcb_%@.jpg",
	@"http://farm5.staticflickr.com/4152/5073149500_cd425316aa_%@.jpg",
	@"http://farm5.staticflickr.com/4113/5073159476_e3e4a8012d_%@.jpg",
	@"http://farm6.staticflickr.com/5087/5321317959_e76841ae53_%@.jpg",
	@"http://farm6.staticflickr.com/5203/5321321061_8845e19c24_%@.jpg",
	@"http://farm6.staticflickr.com/5167/5381267025_c01bc0d3fe_%@.jpg",
	@"http://farm5.staticflickr.com/4048/4467720913_cb6a0fecff_%@.jpg",
	@"http://farm5.staticflickr.com/4022/4471250376_d5cd943477_%@.jpg",
	@"http://farm5.staticflickr.com/4032/4493543468_4fbcf27391_%@.jpg",
	@"http://farm3.staticflickr.com/2748/4493554730_e7c80f29aa_%@.jpg",
	@"http://farm3.staticflickr.com/2720/4500588753_ab38a362c8_%@.jpg",
	@"http://farm5.staticflickr.com/4069/4500590293_541c3c54bc_%@.jpg",
	@"http://farm3.staticflickr.com/2692/4503240831_432e6573ea_%@.jpg",
	@"http://farm5.staticflickr.com/4007/4531147845_91e9c74c5c_%@.jpg",
	@"http://farm5.staticflickr.com/4033/4531151295_dd7223568e_%@.jpg",
	@"http://farm3.staticflickr.com/2678/4531769174_610a1c74cd_%@.jpg",
	@"http://farm5.staticflickr.com/4066/4531776154_5a3e66a31c_%@.jpg",
	@"http://farm5.staticflickr.com/4064/4545877381_c2a2ea2c31_%@.jpg",
	@"http://farm5.staticflickr.com/4015/4592681210_0c893b5254_%@.jpg",
	@"http://farm4.staticflickr.com/3543/4604601562_7083a174d2_%@.jpg",
	@"http://farm2.staticflickr.com/1176/4605070844_ab8c484ea4_%@.jpg",
	@"http://farm5.staticflickr.com/4036/4669466359_3f8abefc75_%@.jpg",
	@"http://farm2.staticflickr.com/1295/4679651173_d9c48e798e_%@.jpg",
	@"http://farm5.staticflickr.com/4018/4680292604_4f35c9dccd_%@.jpg",
};

#define N_RANDOM_WORDS (sizeof(randomWords)/sizeof(NSString *))
#define N_RANDOM_IMAGES (sizeof(randomImgs)/sizeof(NSString *))



#pragma mark -
#pragma mark SnSViewControllerLifeCycle
#pragma mark -

/**
 * Called after the loadView call
 */
- (void)onRetrieveDisplayObjects:(UIView *)view
{
	[super onRetrieveDisplayObjects:view];
	
	// ---------------------------
	// TableView 
	// ---------------------------
	tableView_ = [[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-45)
											   style:UITableViewStylePlain] autorelease];
	tableView_.delegate = self;
	tableView_.dataSource = self;
	
	[self.view addSubview:tableView_];
	
	// ---------------------------
	// ScrollFollower 
	// ---------------------------
	scrollFollower_ = [[SnSScrollFollower alloc] initWithNibName:nil bundle:nil];
	scrollFollower_.scrollFollowed = tableView_;
	[self.view addSubview:scrollFollower_.view];


}

/**
 * Called after the viewDidLoad call
 */
- (void)onRetrieveBusinessObjects
{	
	[super onRetrieveBusinessObjects];
	
}

/**
 * Called after the viewWillAppear call
 */
- (void)onFulfillDisplayObjects
{
	[super onFulfillDisplayObjects];
	
	CGFloat w = 100, h = 40;
	scrollFollower_.view.frame = CGRectMake(VIEW_WIDTH(tableView_)-w-10, 0, w, h);
	
	
}

/**
 * Called after the viewDidAppear call
 */
- (void)onSynchronizeDisplayObjects
{
	[super onSynchronizeDisplayObjects];
	
}

/**
 * Called after the viewDidUnload call
 */
- (void)onDiscarded
{
	[super onDiscarded];
}

#pragma mark -
#pragma mark UITableViewDelegate
#pragma mark -

- (UITableViewCell *)tableView:(UITableView *)iTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"Cell";
	
	ScrollFollowerViewCell *cell = (ScrollFollowerViewCell *)[iTableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	// Tells whether the test will be using drawRect on the cell or
	// use a specific xib in which case its loaded and attached to the cell.
	BOOL isUsingXIB = NO;
	
	// ---------------------------
	// Create Cell 
	// ---------------------------
	if(cell == nil)
	{
		cell = [[[ScrollFollowerViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		
		if (isUsingXIB)
		{
			// Load XIB
			NSArray* objs =  [[NSBundle mainBundle] loadNibNamed:@"test" owner:cell options:nil];
			
			// Attach to cell
			cell = [objs objectAtIndex:0];
		}
	
	}
	
	// ---------------------------
	// Configure Cell
	// ---------------------------
	NSString* imgName = [NSString stringWithFormat:randomImgs[indexPath.row % N_RANDOM_IMAGES], @"s"];

	
	if (isUsingXIB)
	{
		cell.lblFirst.text = cell.firstText ;
		cell.lblText.text = cell.lastText;
		
		[[ScrollFollowerRemoteServices instance] retrieveImageURL:[NSURL URLWithString:imgName]
											   binding:cell.imgTest
											 indicator:nil
									   completionBlock:nil
											errorBlock:nil];
	}
	else
	{
		cell.firstText = randomWords[indexPath.row % N_RANDOM_WORDS];
		cell.lastText = randomWords[(indexPath.row+1) % N_RANDOM_WORDS];
		cell.imgName = imgName;
		[cell downloadImage];
	}	
	
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 50; // arc4random()%150+40;
}

#pragma mark -
#pragma mark UITableViewDataSource
#pragma mark -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 150;
}

#pragma mark -
#pragma mark UIScrollViewDelegate
#pragma mark -

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	SnSLogD(@"%@ - %@ - Inset %.1f %.1f %.1f %.1f", 	
			NSStringFromCGPoint(scrollView.contentOffset), 
			NSStringFromCGSize(scrollView.contentSize),
			scrollView.scrollIndicatorInsets.left, scrollView.scrollIndicatorInsets.right,
			scrollView.scrollIndicatorInsets.top, scrollView.scrollIndicatorInsets.bottom);
	
//	lblfollow_.text = [NSString stringWithFormat:@"%.2f", [scrollFollower_ ratio]];
	[scrollFollower_ follow];
}



#pragma mark -
#pragma mark UIViewController
#pragma mark -

#pragma mark Basics

- (void)dealloc
{
	self.tableView = nil;
	self.scrollFollower = nil;
	
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
