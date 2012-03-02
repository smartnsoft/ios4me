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
 */

#import <UIKit/UIKit.h>

#import "SnSTableViewController.h"

#pragma mark -
#pragma mark SnSFormField

/**
 * Describes a single form attribute.
 */
@interface SnSFormField : NSObject
{
  NSString * name;
  NSString * title;
  id value;
  
  NSIndexPath * indexPath;
  UIKeyboardType keyboardType;
  UITextAutocapitalizationType autocapitalizationType;
  NSString * placeHolder;
  BOOL isSecure;
}

@property(nonatomic, retain) NSString * name;
@property(nonatomic, retain) NSString * title;
@property(nonatomic, retain) id value;

@property(nonatomic, retain) NSIndexPath * indexPath;
@property(nonatomic) UIKeyboardType keyboardType;
@property(nonatomic) UITextAutocapitalizationType autocapitalizationType;
@property(nonatomic, retain) NSString * placeHolder;
@property(nonatomic) BOOL isSecure;

- (NSString *) getStringValue;
- (void) setValueFromString:(NSString *) stringValue;

@end

#pragma mark -
#pragma mark SnSFormDictionary

/**
 * The dictionary which described what are the cells to edit.
 */
@interface SnSFormDictionary : NSObject
{
  @private NSMutableDictionary * sectionTitles;
  @private NSMutableDictionary * indexedDictionary;
  @private NSMutableDictionary * namedDictionary;
  @private NSMutableDictionary * rowsInSection;
}

@property(nonatomic, retain) NSMutableDictionary * sectionTitles;
@property(nonatomic, retain) NSMutableDictionary * indexedDictionary;
@property(nonatomic, retain) NSMutableDictionary * namedDictionary;
@property(nonatomic, retain) NSMutableDictionary * rowsInSection;

- (id) init;
- (void) setTitle:(NSString *)title forSection:(NSInteger)section;
- (NSString *) getTitle:(NSInteger) section;
- (void) addField:(SnSFormField *)formField;
- (SnSFormField *) formFieldForPath:(NSIndexPath *)indexPath;
- (SnSFormField *) formFieldForName:(NSString *)name;
- (NSInteger) numberOfSections;
- (NSInteger) numberOfFieldsInSection:(NSInteger)section;
- (BOOL) isLastField:(NSIndexPath *)indexPath;

@end

#pragma mark -
#pragma mark SnSFormViewController

/**
 * Defines a formular based on a UITableViewController.
 */
@interface SnSFormViewController : SnSTableViewController<UITextFieldDelegate>
{
  @private NSIndexPath * currentlyEditedCell;
}

@property(nonatomic, retain, readonly) NSIndexPath * currentlyEditedCell;
@property(nonatomic, retain, readonly) SnSFormDictionary * formDictionary;

/**
 * @return the dictionary which describes the sorted fields of the form
 */
- (SnSFormDictionary *) computeFormDictionary;

/**
 * The method which is called when the last form cell has been edited.
 */
- (void) onValidate:(id)sender;

@end
