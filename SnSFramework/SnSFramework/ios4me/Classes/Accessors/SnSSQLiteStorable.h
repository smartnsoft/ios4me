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

#import <Foundation/Foundation.h>

#import <sqlite3.h>

// add Methods to NSString Class
#pragma mark -
#pragma mark NSString Utils

@interface NSString (SnSSQLiteStorable)

- (NSString*)stringByEscapingSingleQuotesForSQLite;

- (NSString*)stringByJoiningArray:(NSArray*)iArray;

- (NSString *)initWithSQLiteStatement:(sqlite3_stmt*)iStatement column:(NSInteger)iColumn;

+ (NSInteger)integerFromStatement:(sqlite3_stmt*)iStatement column:(NSInteger)iColumn;

@end

#pragma mark -
#pragma mark Protocols

@protocol SQLiteCommon

/**
 *	Returns the value of the protocol user ID as it is seen in the DB.
 * @return
 *  The value of the object id in db ex: 'value_for_id'
 */
- (NSString*) sqlID;

/**
 *	Returns the column name used as a table main ID. ex. 'wid'
 *  @return
 *  The column name used as a table main ID. ex. 'column_id'
 */
+ (NSString*) sqlColumnNameID;

@optional

/**
 *	Returns the list of columns used to construct queries for 
 *	that business object.
 *  @return
 *  The list of columns used to construct queries.
 *	ex. ['colum_id', 'column1', 'column2']
 */
+ (NSArray*)columnsForSQL;

/**
 * Returns YES if the the SQLite query should remove the sqlColumnNameID
 * from the insert queries or NO Otherwise
 * This is useful when the sqlColumnNameID is an auto incremented integer
 * @return YES if the sqlColumnNameID should be removed from INSERT queries.
 */
+ (BOOL)shouldRemoveColumnNameIDFromInsert;

@end

@protocol SQLiteReadable <SQLiteCommon>

@required

/**
 *	Should return a comma separated string such as column1,column2...
 *	This string should be the same used for select and insert statements
 *
 *  To get all properties of an object (could be useful here for some 
 *  business object models, refer to: http://goo.gl/vMPOh
 *  @return
 *  A comma separated string such as column1,column2...
 */
//+ (NSString*) sqlPreperationForSelect;

/**
 *	A class that responds to the SQLiteReadable protocol should
 *	be able to initate its content from the result of an execucuted statement.
 *	Note that the order of the column to build the Business object should be
 *	known by the class otherwise it will result in corrupted objects
 * @param
 *	The statement resulting from a SELECT statement
 * @result
 *	A safe init value of the object
 */
- (id)initWithSQLiteStatement:(sqlite3_stmt*)iStatement;


@end

@protocol SQLiteWritable <SQLiteCommon>

@required

/**
 *	Should return a comma separated string such as column1,column2...
 *	This string should be the same used for select and insert statements
 *
 *  To get all properties of an object (could be useful here for some 
 *  business object models, refer to: http://goo.gl/vMPOh
 *  @return
 *  A comma separated string such as column1,column2...
 */
//+ (NSString*) sqlPreperationForInsert;

/**
 *	Should return a comma separated escaped string such as quote(value1),quote(value2)...
 *	This string should be the same used for insert statements only.
 *
 *  To get all properties of an object (could be useful here for some 
 *  business object models, refer to: http://goo.gl/vMPOh
 * @return
 *  A comma separated escaped string such as quote(value1),quote(value2)...
 */
- (NSString*) sqlValuesForInsert;

/**
 *  Should return a string such as column1 = 'string1', column2 = integer2
 *	This string should be the same used for update statements only
 * @return
 *  A string such as column1 = value1, column2 = value2
 */
- (NSString*) sqlValuesForUpdate;

@end 

@protocol SQLiteStorable <SQLiteReadable, SQLiteWritable>




@end