//
//  Test-SnSFramework/Test-SQLiteAccessor/TableA.h
//	Test
//
// 	This file was generated by Test-SnSFramework/Resources/sqlite2model.py
//
//  Created by Johan Attali on 2012-03-07.
//  Copyright 2012 Smart&Soft. All rights reserved.
//

/****** SQLite ******/

#import <sqlite3.h>
#define kTableATidColumn 0
#define kTableAIntegColumn 1
#define kTableAVcharColumn 2

#define kTableATidColumnName @"tid"
#define kTableAIntegColumnName @"integ"
#define kTableAVcharColumnName @"vchar"

@interface TableA : NSObject <SQLiteStorable>
{
	NSInteger tid;
	NSInteger integ;
	NSString*	vchar;
}

/****** Properties ******/
@property (nonatomic) NSInteger tid;
@property (nonatomic) NSInteger integ;
@property (nonatomic, retain) NSString* vchar;

- (id)initWithtid:(NSInteger)iTid integ:(NSInteger)iInteg vchar:(NSString*)iVchar ;

/****** SQLite ******/
- (id)initWithSQLiteStatement:(sqlite3_stmt*)iStatement;
- (NSString*) sqlID;
+ (NSString*) sqlColumnNameID;


@end
