//
//  Test-SnSFramework/Test-SQLiteAccessor/TableA.m
//	Test
//
// 	This file was generated by Test-SnSFramework/Resources/sqlite2model.py
//
//  Created by Johan Attali on 2012-03-07.
//  Copyright 2012 Smart&Soft. All rights reserved.
//

#import "TableA.h"

@implementation TableA

@synthesize tid = tid;
@synthesize integ = integ;
@synthesize vchar = vchar;

#pragma mark - Init Methods

- (id)initWithtid:(NSInteger)iTid integ:(NSInteger)iInteg vchar:(NSString*)iVchar 
{
	if (self = [super init])
	{
		tid = iTid;
		integ = iInteg;
		vchar = [iVchar retain];
	}
	return self;
}
- (void)dealloc
{
	[vchar release];

	[super dealloc];
}
- (NSString*)description
{
	return [NSString stringWithFormat:@"%@: -%@- -%@- -%@- ", self.class, 
		[NSString stringWithFormat:@"tid: %d", self.tid],
		[NSString stringWithFormat:@"integ: %d", self.integ],
		[NSString stringWithFormat:@"vchar: %@", self.vchar]];
}

#pragma mark - SQLite Init Methods

- (id)initWithSQLiteStatement:(sqlite3_stmt*)iStatement
{
	if (self = [super init])
	{
		tid = sqlite3_column_int(iStatement, kTableATidColumn);
		integ = sqlite3_column_int(iStatement, kTableAIntegColumn);
		vchar = [[NSString alloc] initWithSQLiteStatement:iStatement column:kTableAVcharColumn];
	}

	return self;
}

#pragma mark - SQLiteStorable

+ (NSString*)sqlColumnNameID
{
	return @"tid";
}

- (NSString*)sqlID
{
	return [NSString stringWithFormat:@"%d", tid];
}	
+ (NSArray*)columnsForSQL
{
    // Retreive main object ID
    NSMutableArray* aArray = [NSMutableArray arrayWithArray:[NSArray array]];

    // Add necessary columns
    [aArray addObjectsFromArray:[NSArray arrayWithObjects:@"tid", @"integ", @"vchar", nil]];

    return aArray;
}

-(NSString*)sqlValuesForInsert
{
    NSString* aValues = @"";
    
    aValues = [NSString stringWithFormat:@"%u, %u, '%@'",
               	tid,
				integ,
				[vchar stringByEscapingSingleQuotesForSQLite]];
    
    return aValues;
}

- (NSString*)sqlValuesForUpdate
{
	NSString* aValues = @"";
    
    aValues = [NSString stringWithFormat:@"%@ = %u, %@ = %u, %@ = '%@'", 
               	@"tid", tid,
				@"integ", integ,
				@"vchar", vchar];
    
    return aValues;
    
}


@end
