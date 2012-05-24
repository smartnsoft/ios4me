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

@interface NSString (SnSExtensionPrivate)

#pragma mark Class Methods

+ (NSString*) stringUnique;

+ (NSInteger)integerFromStatement:(sqlite3_stmt*)iStatement column:(NSInteger)iColumn;
+ (NSInteger)integerFromDictionary:(NSDictionary*)iDict key:(NSString*)iKey;

#pragma mark -
#pragma mark Object Methods
#pragma mark -

#pragma mark Init Methods

- (id)initWithSQLiteStatement:(sqlite3_stmt*)iStatement column:(NSInteger)iColumn;

- (id)initWithDictionary:(NSDictionary *)iDic key:(NSString *)iKey;

#pragma mark - Stripping / Joining

- (NSString*)stringByStrippingHTML;
- (NSString*)stringByEscapingSingleQuotesForSQLite;
- (NSString*)stringByJoiningArray:(NSArray*)iArray;
- (NSString*)stringByStrippingNonNumbers;
- (NSString*)stringByStrippingNumbers;

@end
