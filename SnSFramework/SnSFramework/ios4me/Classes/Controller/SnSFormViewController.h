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
//  SnSFormViewController.h
//  SnSFramwork
//
//  Created by Édouard Mercier on 09/12/09.
//

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
