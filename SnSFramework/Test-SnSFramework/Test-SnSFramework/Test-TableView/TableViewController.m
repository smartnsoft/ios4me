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
//  TableViewController.m
//  Test-SnSFramework
//
//  Created by «FULLUSERNAME» on «DATE».
//  Copyright «YEAR» «ORGANIZATIONNAME». All rights reserved.
//

#import "TableViewController.h"

#import <QuartzCore/QuartzCore.h>
#import <GHUnitIOS/GHUnit.h> 


#define IS_RUNNING_ON_IPAD 0

#define viewWidth self.view.frame.size.width
#define viewHeight self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height

#define kTableCellHeight 50

@interface TableViewControllerCell : UITableViewCell
{
	BOOL isIpad;
}

- (id) initWithIdentifier:(NSString *)reuseIdentifier andResponder:(SnSResponserRedirector *)responderRedirector;
- (void) resize;
- (void) update:(id)businessObject atRow:(NSInteger)row;

@end

@implementation TableViewControllerCell

- (id) initWithIdentifier:(NSString *)reuseIdentifier andResponder:(SnSResponserRedirector *)responderRedirector
{
  if ([self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier] == nil)
  {
    return nil;
  }
	isIpad = [UIDevice isIPad];
	
  return self;
}

- (void) dealloc
{
  [super dealloc];
}

- (void) resizeIPhone
{
	
}

- (void) resizeIPad
{
	
}

- (void) resize
{
  
	if (isIpad) 
	{
		[self resizeIPad];
	}
	else 
	{
		[self resizeIPhone];
	}
}

- (void) fulfillDisplayObject:(id)businessObject
{
	
}

- (void) update:(id)businessObject atRow:(NSInteger)row
{
  [self resize];
}

@end


#pragma mark -
#pragma mark TableViewController

@implementation TableViewController
@synthesize testButton = _testButton;

@synthesize delegate = _delegate;

- (void) onRefresh:(id)sender
{
  [SnSAppDelegate startLoading:self.responderRedirector withMessage:nil ];
  
  [self retrieveBusinessObjectsAndSynchronize];
  
  [SnSAppDelegate stopLoading:self.responderRedirector];
}

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



#pragma mark -
#pragma mark - SnSTableViewController

- (NSArray *) retrieveBusinessObjects
{
	SnSLogD(@"%@::retrieveBusinessObjects", [self class]);
	
	return [NSArray arrayWithObjects:@"A", @"B", @"C", nil];
	

}

- (id) initCellWithIdentifier:(NSString *)reuseIdentifier andResponder:(SnSResponserRedirector *)responderRedirector
{
	SnSLogD(@"%@::initCellWithIdentifier::", [self class]);
	return [[TableViewControllerCell alloc] initWithIdentifier:reuseIdentifier andResponder:self.responderRedirector];
}

- (void) synchronizeDisplay:(UITableViewCell *)cell withBusinessObject:(id)businessObject
{
	SnSLogD(@"%@::synchronizeDisplay", [self class]);
  [((TableViewControllerCell *) cell) fulfillDisplayObject:(NSString *)businessObject];
}

/**
 * The method which is actually called and wrapped when the end-user clicks on a table row.
 */
- (void) tableViewCustom:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[SnSAppDelegate startLoading:self.responderRedirector withMessage:nil];
	
	SnSLogD(@"%@::tableViewCustom: didSelectRowAtIndexPath", [self class]);
	
	
	[SnSAppDelegate stopLoading:self.responderRedirector];
	
	if ([_delegate respondsToSelector:@selector(didCompleteSelectRow)])
		[_delegate didCompleteSelectRow];
}

//
// Uncomment to override the default style
- (void) tableViewCustom:(UITableView *)aTableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
  SnSLogD(@"%@::willDisplayCell cell:%@, cell.backgroundColor : %@", [self class], cell, cell.backgroundColor);
  
  // comment to avoid default style
  [super tableViewCustom:aTableView willDisplayCell:cell forRowAtIndexPath:indexPath];
  
  id currentBusinessObject = (id) [businessObjects objectAtIndex:indexPath.row];
  [((TableViewControllerCell *) cell) update:currentBusinessObject atRow:indexPath.row];
  
}


#pragma mark -
#pragma mark SnSViewControllerLifeCycle

- (void) onRetrieveDisplayObjects:(UIView *)view
{
  [super onRetrieveDisplayObjects:view];
  
	
}

- (void) onRetrieveBusinessObjects
{
	[super onRetrieveBusinessObjects];
	
	if ([_delegate respondsToSelector:@selector(didCompleteRetreiveBusinessObjects)])
		[_delegate didCompleteRetreiveBusinessObjects];

	
}

- (void) onFulfillDisplayObjects
{
  [super onFulfillDisplayObjects];
	
}

- (void) onSynchronizeDisplayObjects
{
  [super onSynchronizeDisplayObjects];
	
	_testButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
	[_testButton addTarget:self action:@selector(clickedTest:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:_testButton];
	
	
}


- (void) onDiscarded
{
  
  [super onDiscarded];
}

#pragma mark - Accessors

- (id)businessObjects
{
	return businessObjects;
}

- (void)clickedTest:(id)sender
{
	SnSLogD(@"");
}

#pragma mark -
#pragma mark SnSViewControllerExceptionHandler

/*
 
 - (BOOL) onBusinessObjectException:(id<SnSViewControllerLifeCycle>)aggregate exception:(SnSBusinessObjectException *)exception resume:(BOOL *)resume;
 - (BOOL) onLifeCycleException:(id<SnSViewControllerLifeCycle>)aggregate exception:(SnSLifeCycleException *)exception resume:(BOOL *)resume;
 - (BOOL) onOtherException:(id<SnSViewControllerLifeCycle>)aggregate exception:(NSException *)exception resume:(BOOL *)resume;
 
 */

#pragma mark -
#pragma mark UITableViewController

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return kTableCellHeight;
}


#pragma mark -
#pragma mark UIViewController

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
	return NO; //DeviceOrientationSupported(interfaceOrientation);
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
