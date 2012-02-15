/* 
 * Copyright (C) 2009 Smart&Soft.
 * All rights reserved.
 *
 * The code hereby is the full property of Smart&Soft, SIREN 517 961 744.
 * http://www.smartnsoft.com - contact@smartnsoft.com
 * 
 * You are not allowed to use the source code or the resulting binary code, nor to modify the source code, without prior permission of the owner.
 *
 * This library is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 */

//
//  SnSFormViewController.m
//  SnSFramework
//
//  Created by Édouard Mercier on 09/12/09.
//

#import "SnSFormViewController.h"

#import "SnSLog.h"
#import "NSObject+SnSExtension.h"

#pragma mark -
#pragma mark SnSFormTableViewCell

@interface SnSFormTableViewCell : UITableViewCell
{
	UILabel * title;
	UITextField * text;	
}

@property (nonatomic, retain) UILabel * title;
@property (nonatomic, retain) UITextField * text;

- (id) initWith:(NSString *)reuseIdentifier andDelegate:(id)delegate andFormField:(SnSFormField *)formField;

@end

@implementation SnSFormTableViewCell

@synthesize title;
@synthesize text;

- (id) initWith:(NSString *)reuseIdentifier andDelegate:(id)delegate andFormField:(SnSFormField *)formField
{
  if ((self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) == nil)
  {
    return nil;
  }
  
  if (formField.title != nil)
  {
    CGFloat halfWidth = [UIScreen mainScreen].bounds.size.width / 2;
    self.title = [[UILabel alloc] initWithFrame:CGRectMake(0, 12, halfWidth, 15)];
    [self.contentView addSubview:title];
    self.text = [[UITextField alloc] initWithFrame:CGRectMake(halfWidth + 5, 7, halfWidth - 3, 25)];
  }
  else
  {
    self.text = [[UITextField alloc] initWithFrame:CGRectMake(5, 7, [UIScreen mainScreen].bounds.size.width - 30, 25)];
  }
  self.text.delegate = delegate;
  if (formField.title != nil)
  {
    self.text.borderStyle = UITextBorderStyleRoundedRect;
  }
  self.text.clearButtonMode = UITextFieldViewModeWhileEditing;
  self.accessoryType = UITableViewCellAccessoryNone;
  self.text.enabled = NO;
  [self.contentView addSubview:text];
  
  return self;
}

- (void) dealloc
{
	[title release];
	[text release];
	
  [super dealloc];
}

@end

#pragma mark -
#pragma mark SnSFormField

@implementation SnSFormField

@synthesize name;
@synthesize title;
@synthesize value;

@synthesize indexPath;
@synthesize keyboardType;
@synthesize autocapitalizationType;
@synthesize placeHolder;
@synthesize isSecure;

- (NSString *) getStringValue
{
  return value;
}

- (void) setValueFromString:(NSString *) stringValue
{
  self.value = stringValue;
}

- (void) dealloc
{
  [name release];
  [title release];
  [value release];
  [indexPath release];
  [placeHolder release];
  
  [super dealloc];
}

@end

#pragma mark -
#pragma mark SnSFormDictionary

@implementation SnSFormDictionary

@synthesize sectionTitles;
@synthesize indexedDictionary;
@synthesize namedDictionary;
@synthesize rowsInSection;

- (id) init
{
  if ((self = [super init]) == nil)
  {
    return nil;
  }
  self.sectionTitles = [[NSMutableDictionary alloc] init];
  self.indexedDictionary = [[NSMutableDictionary alloc] init];
  self.namedDictionary = [[NSMutableDictionary alloc] init];
  self.rowsInSection = [[NSMutableDictionary alloc] init];
  return self;
}

- (void) setTitle:(NSString *)title forSection:(NSInteger)section
{
  [self.sectionTitles setObject:title forKey:[NSNumber numberWithInteger:section]];
}

- (NSString *) getTitle:(NSInteger) section
{
  return [self.sectionTitles objectForKey:[NSNumber numberWithInteger:section]];
}

- (void) addField:(SnSFormField *)formField
{
  [self.indexedDictionary setObject:formField forKey:formField.indexPath];
  [self.namedDictionary setObject:formField forKey:formField.name];
  NSNumber * section = [NSNumber numberWithInteger:formField.indexPath.section];
  NSNumber * theRowsInSection = [self.rowsInSection objectForKey:section];
  if (theRowsInSection == nil)
  {
    [self.rowsInSection setObject:[NSNumber numberWithInteger:1] forKey:section];
    return;
  }
  else
  {
    [self.rowsInSection setObject:[NSNumber numberWithInteger:[theRowsInSection integerValue] + 1] forKey:section];
  }
}

- (SnSFormField *) formFieldForPath:(NSIndexPath *)indexPath
{
  return [indexedDictionary objectForKey:indexPath];
}

- (SnSFormField *) formFieldForName:(NSString *)name
{
  return [namedDictionary objectForKey:name];
}

- (NSInteger) numberOfSections
{
  return [self.rowsInSection count];
}

- (NSInteger) numberOfFieldsInSection:(NSInteger)section
{
  return [((NSNumber *) [self.rowsInSection objectForKey:[NSNumber numberWithInteger:section]]) integerValue];
}

- (BOOL) isLastField:(NSIndexPath *)indexPath
{
  if (indexPath.section < ([self numberOfSections] - 1))
  {
    return NO;
  }
  return indexPath.row == ([self numberOfFieldsInSection:indexPath.section] - 1);
}

- (NSIndexPath *) nextIndexPath:(NSIndexPath *) indexPath
{
  if (indexPath.row < ([self numberOfFieldsInSection:indexPath.section] - 1))
  {
    return [[NSIndexPath indexPathWithIndex:indexPath.section] indexPathByAddingIndex:(indexPath.row + 1)];
  }
  else
  {
    return [[NSIndexPath indexPathWithIndex:(indexPath.section + 1)] indexPathByAddingIndex:0];
  }
}

- (void) dealloc
{
  [sectionTitles release];
  [indexedDictionary release];
  [namedDictionary release];
  [rowsInSection release];
  
  [super dealloc];
}

@end

#pragma mark -
#pragma mark SnSFormViewController

@implementation SnSFormViewController

@synthesize currentlyEditedCell;

- (id) init
{
  if ((self = [super initWithStyle:UITableViewStyleGrouped]) == nil)
  {
    return nil;
  }
  return self;
}

- (SnSFormDictionary *) formDictionary
{
  return businessObjects;
}

- (SnSFormDictionary *) computeFormDictionary
{
  return nil;
}

- (void) onValidate:(id)sender
{
}

- (void) onValidateInternalInNewThread:(id)sender
{
  // We make sure that exceptions are handled
  [[SnSApplicationController instance] performSelectorByHandlingException:self aggregate:self delegate:[SnSDelegateWithObject delegateWith:self andSelector:@selector(onValidate:) andObject:sender]];
}

- (void) onValidateInternal:(id)sender
{
  SnSFormTableViewCell * cell = (SnSFormTableViewCell *) [self.tableView cellForRowAtIndexPath:currentlyEditedCell];
  [cell.text resignFirstResponder];
  cell.text.enabled = NO;
  // We do that in a background thread, so as to relief the caller thread
  [self performSelectorInBackgroundWithAutoreleasePool:@selector(onValidateInternalInNewThread:) withObject:sender];
}

#pragma mark -
#pragma mark UITextFieldDelegate

- (void) onCancelEdition:(id)sender
{
  SnSFormTableViewCell * cell = (SnSFormTableViewCell *) [self.tableView cellForRowAtIndexPath:self.currentlyEditedCell];
  [cell.text resignFirstResponder];
  self.navigationItem.leftBarButtonItem = nil;
  [sender release];
}

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(onCancelEdition:)];
}

- (void) textFieldDidEndEditing:(UITextField *)textField
{
  [textField resignFirstResponder];
  textField.enabled = NO;
  self.navigationItem.leftBarButtonItem = nil;
  SnSFormTableViewCell * cell = (SnSFormTableViewCell *) [self.tableView cellForRowAtIndexPath:currentlyEditedCell];
  SnSFormField * SnSFormField = [businessObjects formFieldForPath:currentlyEditedCell];
  [SnSFormField setValueFromString:cell.text.text];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
  if ([businessObjects isLastField:self.currentlyEditedCell] == NO)
  {
    NSIndexPath * nextIndexPath = [businessObjects nextIndexPath:self.currentlyEditedCell];
    SnSFormTableViewCell * nextCell = (SnSFormTableViewCell *) [self.tableView cellForRowAtIndexPath:nextIndexPath];
    nextCell.text.enabled = YES;
    [nextCell.text becomeFirstResponder];
    currentlyEditedCell = [nextIndexPath retain];
    [nextIndexPath release];
  }
  else
  {
    // This is the last cell, and we simulate a validation
    [textField resignFirstResponder];
    textField.enabled = NO;
    [self onValidateInternal:self];
  }
  return YES;
}

#pragma mark -
#pragma mark SnSViewControllerLifeCycle

- (void) onRetrieveDisplayObjects:(UIView *)view
{
  [super onRetrieveDisplayObjects:view];
}

- (void) onRetrieveBusinessObjects
{
  businessObjects = [[self computeFormDictionary] retain];
}

- (void) onFulfillDisplayObjects
{
  [super onFulfillDisplayObjects];
}

- (void) onSynchronizeDisplayObjects
{
  [super onSynchronizeDisplayObjects];
  [self.tableView reloadData];
}

- (void) onDiscarded
{
  [currentlyEditedCell release];
  [super onDiscarded];
}

#pragma mark -
#pragma mark NSObject

- (void) dealloc
{
  [currentlyEditedCell release];

  [super dealloc];
}

#pragma mark -
#pragma mark UITableViewController

- (NSInteger) numberOfSectionsInTableView:(UITableView *)theTableView
{
  return [businessObjects numberOfSections];
}

- (NSInteger) tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section
{
  return [businessObjects numberOfFieldsInSection:section];
}

- (UITableViewCell *) tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString * cellIdentifier = @"formTableViewCell";
  
  SnSFormTableViewCell * cell = (SnSFormTableViewCell *) [theTableView dequeueReusableCellWithIdentifier:cellIdentifier];
  SnSFormField * formField = [businessObjects formFieldForPath:indexPath];
  if (cell == nil)
  {
		cell = [[[SnSFormTableViewCell alloc] initWith:cellIdentifier andDelegate:self andFormField:(SnSFormField *)formField] autorelease];
  }
  cell.title.text = formField.title;
  cell.text.text = [formField getStringValue];
  cell.text.autocapitalizationType = formField.autocapitalizationType;
  cell.text.placeholder = formField.placeHolder;
  cell.text.keyboardType = formField.keyboardType;
  cell.text.secureTextEntry = formField.isSecure;
  if ([businessObjects isLastField:indexPath] == NO)
  {
    cell.text.returnKeyType = UIReturnKeyNext;
  }
  else
  {
    cell.text.returnKeyType = UIReturnKeyDone;
  }
  return cell;
}

- (NSString *) tableView:(UITableView *)theTableView titleForHeaderInSection:(NSInteger)section
{
  return [businessObjects getTitle:section];
}

- (CGFloat) tableView:(UITableView *)theTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 39.0;
}

- (void) tableViewCustom:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [theTableView deselectRowAtIndexPath:indexPath animated:YES];
  SnSFormTableViewCell * cell = (SnSFormTableViewCell *) [theTableView cellForRowAtIndexPath:indexPath];
  cell.text.enabled = YES;
  [cell.text becomeFirstResponder];
  currentlyEditedCell = [indexPath retain];
}

@end
