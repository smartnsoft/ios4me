//
//  Test-StoreManager.m
//  Test-SnSFramework
//
//  Created by Johan Attali on 8/10/11.
//  Copyright 2011 Smart&Soft. All rights reserved.
//

// For iOS
#import <GHUnitIOS/GHUnit.h> 
// For Mac OS X
//#import <GHUnit/GHUnit.h>

#import "Test-SQLiteAccessor.h"
#import "TableA.h"


#pragma mark - Test_SQL_Accessor


@implementation Test_SQL_Accessor

- (NSString *)databaseName { return @"test_sqlite.sql"; }

@end

#pragma mark - GHTestCase


@implementation TestSQLiteAccessor

- (BOOL)shouldRunOnMainThread {
    // By default NO, but if you have a UI test or test dependent on running on the main thread return YES.
    // Also an async test that calls back on the main thread, you'll probably want to return YES.
    return NO;
}

- (void)setUpClass {
    // Run at start of all tests in the class
}

- (void)tearDownClass {
    // Run at end of all tests in the class
}

- (void)setUp {
    // Run before each test method
}

- (void)tearDown {
    // Run after each test method
}  

/** 
 *	This is the first test that should be exectuted and will test if the
 *	the database is correctly created
 */
- (void)test01_CreateDatabase
{
	NSString* aDBPath = [[Test_SQL_Accessor instance] databasePath];
	
	GHAssertFalse([[NSFileManager defaultManager] fileExistsAtPath:aDBPath], @"A database is already present at %@: ", aDBPath);
	
	[[Test_SQL_Accessor instance] createDatabaseIfNeeded];
	
	GHAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:aDBPath], @"The database failed to be created at %@: ", aDBPath);

}

/** 
 *	Test insertion into the database
 */
- (void)test02_Insert
{
	NSInteger aNbElementsToInsert = 50;
	
	for (NSInteger i = 0; i < aNbElementsToInsert; i++)
	{
		TableA* aElement = [[TableA alloc] init];
		aElement.integ = i;
		aElement.vchar = [NSString stringWithFormat:@"%s",__FUNCTION__];
		
		GHAssertTrue([[Test_SQL_Accessor instance] insert:aElement], @"Failed to insert element: %@", aElement);
	}
	
	
}

/**
 * This test should be kept at end and test the correct removal of the database
 */
- (void)test99_RemoveDatabase
{
	NSString* aDBPath = [[Test_SQL_Accessor instance] databasePath];
	
	GHAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:aDBPath], @"A database is already present at %@: ", aDBPath);
	
	[[Test_SQL_Accessor instance] removeDatabase];
	
	GHAssertFalse([[NSFileManager defaultManager] fileExistsAtPath:aDBPath], @"The database failed to be created at %@: ", aDBPath);

}

@end