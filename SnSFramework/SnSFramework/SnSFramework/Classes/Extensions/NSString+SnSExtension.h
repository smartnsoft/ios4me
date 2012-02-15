//
//  NSString+SnSExtension.h
//  SnSFramework
//
//  Created by Johan Attali on 8/4/11.
//  Copyright 2011 Smart&Soft. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <sqlite3.h>

@interface NSString (SnSExtensionPrivate)

+ (NSString*) stringUnique;

- (NSString*)stringByEscapingSingleQuotesForSQLite;

- (NSString*)stringByJoiningArray:(NSArray*)iArray;

- (NSString *)initWithSQLiteStatement:(sqlite3_stmt*)iStatement column:(NSInteger)iColumn;

+ (NSInteger)integerFromStatement:(sqlite3_stmt*)iStatement column:(NSInteger)iColumn;

+ (NSInteger)integerFromDictionary:(NSDictionary*)iDict key:(NSString*)iKey;

- (NSString*) stringByStrippingNonNumbers;

@end
