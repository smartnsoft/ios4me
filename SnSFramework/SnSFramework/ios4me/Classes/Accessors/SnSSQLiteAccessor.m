//
//  SnSSQLiteAccessor.m
//  SnSFramework
//
//  Created by Johan Attali on 8/12/11.
//  Copyright 2011 Smart&Soft. All rights reserved.
//

#import "SnSSQLiteAccessor.h"
#import "SnSUtils.h"
#import "SnSConstants.h"
#import "SnSLog.h"

@implementation SnSSQLiteAccessor 

@synthesize lastInsertedRowID = _lastInsertedRowID;

#pragma mark - Phyisical DB Actions Related 

- (Boolean) createDatabaseIfNeeded
{
    Boolean aSuccess = NO;
    
    // Retreives path to lacal database
	NSString* aDatabasePath = [self databaseFullPath];
	
	// Create a FileManager object, we will use this to check the status
	// of the database and to copy it over if required
	NSFileManager *aFileManager = [NSFileManager defaultManager];
	
	// Check if the database has already been created in the users filesystem
	Boolean isDBAlreadyExisting = [aFileManager fileExistsAtPath:aDatabasePath];
    
    SnSLogI(@"[Database] Path for internal database: %@", aDatabasePath);
	SnSLogI(@"[Database] Database Creation needed ? ", !isDBAlreadyExisting);
	
	if (!isDBAlreadyExisting)
    {
		aSuccess = [self resetDatabase];
        SnSLogD(@"[Database] Database Creation Success ? %u", aSuccess);
    }
    
    
    
	return aSuccess;
}

- (Boolean) patchDatabaseIfNeeded
{
    Boolean aPatchedNeeded = NO;
    
    /** Put here the code to check if a patch is needed (note that this can change and evolve in time)	**/
	/** Example, you added a column 'new_col' to your table 'my_table' you could do something like:		**/
	/*
	aPatchedNeeded  = ![self executeQuery:@"SELECT new_col from my_table"];
    if (aPatchedNeeded)
	{
		if (![self executeQuery:@"ALTER TABLE my_table ADD COLUMN new_col BOOL NOT NULL DEFAULT 0"])
			SnSLogE(@"Failed to patch database");
	}
	*/
	
	return aPatchedNeeded;
}

- (Boolean) resetDatabase
{
    Boolean aSuccess = NO;
    NSError* aError = nil;
    
    // Retreives path to lacal database
	NSString* aDatabasePath = [self databaseFullPath];
	
	// Create a FileManager object, we will use this to check the status
	// of the database and to copy it over if required
	NSFileManager *aFileManager = [NSFileManager defaultManager];
	
	SnSLogD(@"Resetting database at path: %@", aDatabasePath);

	
	// Check if the database has already been created in the users filesystem
	Boolean isDBAlreadyExisting = [aFileManager fileExistsAtPath:aDatabasePath];
    
	// Removes the existing database if already existing
	if (isDBAlreadyExisting)
	{
		[aFileManager removeItemAtPath:aDatabasePath error:&aError];
		
		// Handle the error if any
		if (aError != nil)
			SnSLogE(@"Failed to delete previous database. Reason @", [aError description]);

	}
	// otherwise create the path that will hold it
	else
	{
		[aFileManager createDirectoryAtPath:[self databasePath]
				withIntermediateDirectories:YES
								 attributes:nil
									  error:&aError];
		if (aError)
			SnSLogE(@"Failed to create database path %@", [self databasePath]);
	}
	
	// Do not forget to include the db inside the XCode project itself for it to be copied
	// to its final path. Also this should only host the first and original version !
	// All other changes should be made through the the copy inside the Documents Folder
	// For all future updates, go through the patchDatabaseIfNeeded
	NSString *aDatabasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[self databaseName]];
	
	NSString* aDatabaseContent = [NSString stringWithContentsOfFile:aDatabasePathFromApp
														   encoding:NSUTF8StringEncoding 
															  error:&aError];
	
	if (aError)
		SnSLogE(@"Failed to read database file. Reason: @", [aError description]);
	else
		aSuccess = [self executeQuery:aDatabaseContent];

	//aSuccess = [aFileManager copyItemAtPath:aDatabasePathFromApp toPath:aDatabasePath error:&aError];
	
//	// Handle the error if any
//	if (aError != nil)
//		SnSLogE(@"%@", [aError description]);
	
	return aSuccess;
	
}

/**
 *	Removes the database from the filesystem
 * @result
 *  True if the action was correctly processed.
 */
- (Boolean)removeDatabase
{
	Boolean aRemoved = NO;
    NSError* aError = nil;
    
    // Retreives path to lacal database
	NSString* aDatabasePath = [self databaseFullPath];
	
	SnSLogD(@"Removing database at path: %@", aDatabasePath);

	
	// Create a FileManager object, we will use this to check the status
	// of the database and to copy it over if required
	NSFileManager *aFileManager = [NSFileManager defaultManager];
	
	if ([aFileManager fileExistsAtPath:aDatabasePath])
	{
		[aFileManager removeItemAtPath:aDatabasePath error:&aError];
		
		// Handle the error if any
		if (aError != nil)
			SnSLogE(@"%@", [aError description]);
		else
			aRemoved = YES;
	}
	
	return aRemoved;
}

- (NSString*)databaseFullPath
{
	return [[self databasePath] stringByAppendingPathComponent:[self databaseName]];
}

- (NSString*)databasePath
{	
    return [[SnSUtils applicationCachesPath] stringByAppendingPathComponent:SnSSQLiteAccessorFolderName];
}
		 
- (NSString*)databaseName
{
	return @"The DB Name should be set by your master accessor";
}

#pragma mark - Preperation

- (NSString*) preparationStatement
{
    return nil;
}

- (NSString*) preparationForInsert:(Class)iBusinessObjectClass
{
	NSString* aPreparation = [NSString stringWithFormat:@"You must define +columnsForSQL and +sqlColumnNameID in the class %@", iBusinessObjectClass];
	
	if ([iBusinessObjectClass respondsToSelector:@selector(columnsForSQL)] && 
		[iBusinessObjectClass respondsToSelector:@selector(sqlColumnNameID)])
	{
		// Retreives all columns
		NSMutableArray* aColumnsForStatement = [NSMutableArray arrayWithArray:[iBusinessObjectClass columnsForSQL]];
		
		// Remove auto increment ID from insert statement if needed
		if ([iBusinessObjectClass respondsToSelector:@selector(shouldRemoveColumnNameIDFromInsert)] &&
			[iBusinessObjectClass shouldRemoveColumnNameIDFromInsert])
			[aColumnsForStatement removeObject:[iBusinessObjectClass sqlColumnNameID]];
		
		// Loop on all columns to add necessary elements (commas...)
		aPreparation = [aColumnsForStatement componentsJoinedByString:@","];

	}
    
	    
    return aPreparation;
}

- (NSString *)preparationForSelect:(Class)iBusinessObjectClass
{
	NSString* aPreparation = [NSString stringWithFormat:@"You must define +columnsForSQL in the class: %@", iBusinessObjectClass];
    
	if ([iBusinessObjectClass respondsToSelector:@selector(columnsForSQL)])
	{
		// Retreives all columns
		NSArray* aColumnsForStatement = [iBusinessObjectClass columnsForSQL];
		
		// Loop on all columns to add necessary elements (commas...)
		aPreparation = [aColumnsForStatement componentsJoinedByString:@","];

	}
	
    
    return aPreparation;
}


#pragma mark - Execution Status

- (void)didFailToExecute:(NSString*)iQuery parameter:(id)iParameter
{
    
    NSString* aErrorInfo = @"";
    
    // Number ? -> Number of Rows Fetched
	if ([iParameter isKindOfClass:[NSNumber class]])
		aErrorInfo = [self sqlInformatiomFromCode:[iParameter intValue]];
    else if ([iParameter isKindOfClass:[NSString class]])
        aErrorInfo = iParameter;
    
	NSString* aLogString	= @"**********************************************************************";
    
	NSString* aErrorString			= [NSString stringWithFormat:@"\n%@\n\tError %@ \n\tFailed to execute: \n\t%@\n%@", aLogString, aErrorInfo, iQuery, aLogString];
	NSDictionary* aErrorDictionary	= [NSDictionary dictionaryWithObjectsAndKeys:aErrorString, NSLocalizedDescriptionKey, nil];
	
	NSError* aError = [NSError errorWithDomain:@"WeekMateDomain"
										  code:0 
									  userInfo:aErrorDictionary];
	
	
	SnSLogE([aError localizedDescription]);
}

- (void)didSucceedToExecute:(NSString*)iQuery parameter:(id)iParameter
{
	
	NSString* aInfo = @"";
	
	// Number ? -> Number of Rows Fetched
	if ([iParameter isKindOfClass:[NSNumber class]])
    {
        NSInteger aRowsInvolved = [iParameter intValue]; 
        NSRange aRangeSelect = [iQuery rangeOfString:@"SELECT"];
        NSRange aRangeInsert = [iQuery rangeOfString:@"INSERT"];
        NSRange aRangeDelete = [iQuery rangeOfString:@"DELETE"];
        
        if (aRangeSelect.location != NSNotFound)
            aInfo = [NSString stringWithFormat:@" [%u Row%@ Selected] ", aRowsInvolved, aRowsInvolved > 1 ? @"s" : @""];
        
        if (aRangeInsert.location != NSNotFound)
            aInfo = [NSString stringWithFormat:@" [%u Row%@ Inserted] ", aRowsInvolved, aRowsInvolved > 1 ? @"s" : @""];
        
        if (aRangeDelete.location != NSNotFound)
            aInfo = [NSString stringWithFormat:@" [%u Row%@ Deleted] ", aRowsInvolved, aRowsInvolved > 1 ? @"s" : @""];
    }
    
    if (_lastInsertedRowID != 0)
        aInfo = [aInfo stringByAppendingFormat:@" [Last ID Insterted: %u] ", _lastInsertedRowID];
	
	NSString* aLogString	= @"--------------------------------------------------------------";
	
	// Log Query
	SnSLogD(@"\n---- SQL Query Executed Succesfully %@:\n%@\n%@\n%@",aInfo,aLogString,iQuery,aLogString);
}

- (NSString*) sqlInformatiomFromCode:(NSInteger)iErrorCode
{
	NSString* aErrorType = @"";
	switch (iErrorCode)
	{
		case SQLITE_ERROR:
			aErrorType = @" SQLITE_ERROR         (SQL error or missing database)";
			break;
			
		case SQLITE_INTERNAL:
			aErrorType = @" SQLITE_INTERNAL      (Internal logic error in SQLite)";
			break;
			
		case SQLITE_PERM:
			aErrorType = @" SQLITE_PERM          (Access permission denied)";
			break;
			
		case SQLITE_ABORT:
			aErrorType = @" SQLITE_ABORT         (Callback routine requested an abort)";
			break;
			
		case SQLITE_BUSY:
			aErrorType = @" SQLITE_BUSY          (The database file is locked)";
			break;
			
		case SQLITE_LOCKED:
			aErrorType = @" SQLITE_LOCKED        (A table in the database is locked)";
			break;
			
		case SQLITE_NOMEM:
			aErrorType = @" SQLITE_NOMEM         (A malloc() failed)";
			break;
			
		case SQLITE_READONLY:
			aErrorType = @" SQLITE_READONLY      (Attempt to write a readonly database)";
			break;
			
		case SQLITE_INTERRUPT:
			aErrorType = @" SQLITE_INTERRUPT     (Operation terminated by sqlite_interrupt())";
			break;
			
		case SQLITE_CORRUPT:
			aErrorType = @" SQLITE_CORRUPT       (The database disk image is malformed)";
			break;
			
		case SQLITE_NOTFOUND:
			aErrorType = @" SQLITE_NOTFOUND      (NOT USED. Table or record not found)";
			break;
			
		case SQLITE_FULL:
			aErrorType = @" SQLITE_FULL          (Insertion failed because database is full)";
			break;
			
		case SQLITE_CANTOPEN:
			aErrorType = @" SQLITE_CANTOPEN      (Unable to open the database file)";
			break;
			
		case SQLITE_PROTOCOL:
			aErrorType = @" SQLITE_PROTOCOL      (Database lock protocol error)";
			break;
			
		case SQLITE_EMPTY:
			aErrorType = @" SQLITE_EMPTY         (Database is empty)";
			break;
			
		case SQLITE_SCHEMA:
			aErrorType = @" SQLITE_SCHEMA        (The database schema changed)";
			break;
			
		case SQLITE_TOOBIG:
			aErrorType = @" SQLITE_TOOBIG        (String or BLOB exceeds size limit)";
			break;
			
		case SQLITE_CONSTRAINT:
			aErrorType = @" SQLITE_CONSTRAINT    (Abort due to constraint violation)";
			break;
			
		case SQLITE_MISMATCH:
			aErrorType = @" SQLITE_MISMATCH      (Data type mismatch)";
			break;
			
		case SQLITE_MISUSE:
			aErrorType = @" SQLITE_MISUSE        (Library used incorrectly)";
			break;
			
		case SQLITE_NOLFS:
			aErrorType = @" SQLITE_NOLFS         (Uses OS features not supported on host)";
			break;
			
		case SQLITE_AUTH:
			aErrorType = @" SQLITE_AUTH          (Authorization denied)";
			break;
			
		case SQLITE_FORMAT:
			aErrorType = @" SQLITE_FORMAT        (Auxiliary database format error)";
			break;
			
		case SQLITE_RANGE:
			aErrorType = @" SQLITE_RANGE         (2nd parameter to sqlite_bind out of range)";
			break;
			
		case SQLITE_NOTADB:
			aErrorType = @" SQLITE_NOTADB        (File opened that is not a database file)";
			break;
			
		case SQLITE_ROW:
			aErrorType = @" SQLITE_ROW           (sqlite_step() has another row ready)";
			break;
			
		case SQLITE_DONE:
			aErrorType = @" SQLITE_DONE          (sqlite_step() has finished executing)";
			break;
		default:
			aErrorType = @" unknown";
			break;
	}
	
	return aErrorType;
}

#pragma mark - Execution

- (NSInteger)lastInsertRowID:(sqlite3*)pDatabase
{
    NSInteger aRet = 0;
    sqlite3_stmt *statement;
    
    // Preparing a statement compiles the SQL query into a byte-code program in the SQLite library.
    // The third parameter is either the length of the SQL string or -1 to read up to the first null terminator. 
    NSInteger aResult = sqlite3_prepare_v2(pDatabase, "SELECT last_insert_rowid()", -1, &statement, NULL);
    
    if (aResult == SQLITE_OK) 
    {
        // We "step" through the results - once for each row.
        // Though for the purpose of this function, only one row should be there.
        while (sqlite3_step(statement) == SQLITE_ROW) 
            aRet = [NSString integerFromStatement:statement column:0];
    }
    
    // "Finalize" the statement - releases the resources associated with the statement.
    sqlite3_finalize(statement);
    
    return aRet;
}

- (NSObject<SQLiteReadable>*)businessObjectFromID:(NSString*)iObjectID object:(Class<SQLiteReadable>)iClass
{
    // Creating Select Query
	NSString* aQuery = [NSString stringWithFormat:@"SELECT %@ FROM %@ WHERE %@ = '%@'",
						[self preparationForSelect:iClass],
                        iClass,
                        [iClass sqlColumnNameID],
                        iObjectID];
    
    // Retrieve the DB object if already existing
	NSArray* aArray = [self arrayOfObjectsFromQuery:aQuery object:iClass];
	
	// The array can be empty while the user has not validated its first settings
	if ([aArray count] == 0)
		return nil;
	
	// Otherwise returns the first object
	return [aArray objectAtIndex:0];
}



- (NSArray*)arrayOfObjectsFromQuery:(NSString*)iQuery object:(Class)iClass
{
    NSMutableArray* aArray	= [[[NSMutableArray alloc] init] autorelease];
	NSString* aDBpath		= [self databaseFullPath];
	
	// Holds the database connection
	sqlite3* aDatabase;
    
	if (sqlite3_open([aDBpath UTF8String], &aDatabase) == SQLITE_OK)
	{
		sqlite3_stmt *statement;
		
		// Preparing a statement compiles the SQL query into a byte-code program in the SQLite library.
		// The third parameter is either the length of the SQL string or -1 to read up to the first null terminator. 
		NSInteger aResult = sqlite3_prepare_v2(aDatabase, [iQuery cStringUsingEncoding:NSUTF8StringEncoding], -1, &statement, NULL);
		if (aResult == SQLITE_OK) 
		{
			NSInteger aNbFetchedObject = 0;
			// We "step" through the results - once for each row.
			while (sqlite3_step(statement) == SQLITE_ROW) 
			{
                // Only call the initWithSQLiteStatement if the object to build responds to it
                NSObject* aObjTest = [[[iClass class] alloc] init];
				if ([aObjTest respondsToSelector:@selector(initWithSQLiteStatement:)])
                {
                    // Use our own init function with the current statement
                    NSObject* aDBObject = [[iClass alloc] initWithSQLiteStatement:statement];
                    // Store object into returned array
                    [aArray addObject:aDBObject];
                    // can be released since it's retained in the clips array
                    [aDBObject release];
                }
                else
                    SnSLogE(@"%@ doesn't respond to: initWithSQLiteStatement:", [aObjTest class]);
                
                [aObjTest release];
				
				// Increase number of fetched objects
				++aNbFetchedObject;
			}
			
			[self didSucceedToExecute:iQuery parameter:[NSNumber numberWithInt:aNbFetchedObject]];
		}
		else
			[self didFailToExecute:iQuery parameter:[NSNumber numberWithInt:aResult]];
		
		// "Finalize" the statement - releases the resources associated with the statement.
		sqlite3_finalize(statement);
		
	}
	
	// Safely close database even if the connection was not done.
	sqlite3_close(aDatabase);
	
	return aArray;
	
}


- (BOOL)executeQuery:(NSString*)iQuery
{
    NSString* DBpath		= [self databaseFullPath];
	// Holds the database connection
	sqlite3* database;
	
	NSInteger ret = sqlite3_open_v2([DBpath UTF8String], &database, SQLITE_OPEN_NOMUTEX|SQLITE_OPEN_READWRITE|SQLITE_OPEN_CREATE,NULL);
	NSInteger changes = 0;
	if (ret == SQLITE_OK)
	{
		sqlite3_stmt *statement = NULL;
		const char* utf8query = [iQuery cStringUsingEncoding:NSUTF8StringEncoding];
		const char* pzTail = NULL;
		while (utf8query != NULL && strlen(utf8query) > 0)
		{
			// Preparing a statement compiles the SQL query into a byte-code program in the SQLite library.
			// The third parameter is either the length of the SQL string or -1 to read up to the first null terminator. 
			BOOL preparation = sqlite3_prepare_v2(database, utf8query, -1, &statement, &pzTail);
			
			// Step through the statement even if failed to retrieve the error code
			ret = sqlite3_step(statement);
			
			// "Finalize" the statement - releases the resources associated with the statement.
			sqlite3_finalize(statement);
			
			if (preparation == SQLITE_OK) 
			{
				// Before closing the connection, retreive the last row inserted
				_lastInsertedRowID = [self lastInsertRowID:database];
				
				// How many rows were modified by the last statement
				changes = sqlite3_changes(database);
				
				// If pzTail is not NULL then *pzTail is made to point to the first byte past the end of the first SQL statement
				// in zSql. These routines only compile the first statement in zSql, so *pzTail is left pointing to what remains uncompiled.
				utf8query = pzTail;
			}
			// Error code on preparation ? stop right there
			else
				utf8query = NULL;
		}		
	}
	
	// Safely close database even if the connection was not done.
	sqlite3_close(database);
	
	// Log Error if ret is not ok
	if (ret != SQLITE_OK && ret != SQLITE_DONE &&  ret != SQLITE_ROW)
		[self didFailToExecute:iQuery parameter:[NSNumber numberWithInt:ret]];
	else
		[self didSucceedToExecute:iQuery parameter:[NSNumber numberWithInt:changes]];
	
	return (ret == SQLITE_OK || ret == SQLITE_DONE || ret == SQLITE_ROW);
	
}


#pragma mark - INSERT/UPDATE/DELETE 


- (BOOL)deleteBusinessObject:(NSObject<SQLiteReadable>*)iBusinessObject
{
    // Creating Select Query
	NSString* aQuery = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = '%@'",
                        [iBusinessObject class],
                        [[iBusinessObject class] sqlColumnNameID],
                        [iBusinessObject sqlID]];
	
	// Otherwise returns the first object
	return [self executeQuery:aQuery];
}

- (BOOL)deleteAllFromTable:(Class<SQLiteWritable>)iClass
{
    // Creating Select Query
	NSString* aQuery = [NSString stringWithFormat:@"DELETE FROM %@",
                        iClass];
	
	// Otherwise returns the first object
	return [self executeQuery:aQuery];
}

- (BOOL)save:(NSObject<SQLiteStorable>*)iBusinessObject withForeignKeys:(NSDictionary*)iFKeys
{
    // Preparation Strings
	NSString* aMainColumn			= [[iBusinessObject class] sqlColumnNameID];
	NSString* aSelectPreparation	= [self preparationForSelect:[iBusinessObject class]];
	NSString* aMainID				= [iBusinessObject sqlID];
	
	// Query building
	NSString* aQuery = [NSString stringWithFormat:@"SELECT %@ FROM %@ WHERE %@ = '%@'", 
						aSelectPreparation, [iBusinessObject class], 						// SELECT
						aMainColumn, aMainID												// WHERE
						];
	
    
    // See if a business object matches that query to trigger insert or update
	NSArray* aFetchedObject = [self arrayOfObjectsFromQuery:aQuery object:[iBusinessObject class]];
    
    Boolean aRetValue = NO;
    if ([aFetchedObject count] > 0)
        aRetValue = [self update:iBusinessObject];
    else
        aRetValue = [self insert:iBusinessObject withForeignKeys:iFKeys];
	
	return aRetValue;
}

- (BOOL)save:(NSObject<SQLiteWritable,SQLiteReadable>*)iBusinessObject
{
	return [self save:iBusinessObject withForeignKeys:nil];
}


- (BOOL)insert:(NSObject<SQLiteWritable>*)iBusinessObject withForeignKeys:(NSDictionary*)iFKeys
{
    // Preparation Strings
	NSString* aSQLPreparation	= [self preparationForInsert:[iBusinessObject class]];
    NSString* aSQLValues        = [iBusinessObject sqlValuesForInsert];
    
    // Treat Foreign keys if present
    if ([iFKeys count] > 0)
    {        
        // Make sure the order remains the same !
        NSMutableArray* aFKeys      = [NSMutableArray array];
        NSMutableArray* aFValues    = [NSMutableArray array];

        for (NSString* aFKey in iFKeys)
        {
            [aFValues addObject:[iFKeys objectForKey:aFKey]];
            [aFKeys addObject:aFKey];
        }
        
        // Add Keys to Prep Statement
        aSQLPreparation = [aSQLPreparation stringByAppendingFormat:@",%@", [@"," stringByJoiningArray:aFKeys]];
        
        // Add values to Values Statement
        aSQLValues = [aSQLValues stringByAppendingFormat:@",%@", [@"," stringByJoiningArray:aFValues]];
    }
    
    // Query building
	NSString* aQuery = [NSString stringWithFormat:@"INSERT INTO %@ (%@) VALUES (%@)", 
						[iBusinessObject class], 			// CLASS
						aSQLPreparation,                    // COLUMNS
                        aSQLValues                          // VALUES
						];
    
	return [self executeQuery:aQuery];
}

- (BOOL)insert:(NSObject<SQLiteWritable>*)iBusinessObject
{
    return [self insert:iBusinessObject withForeignKeys:nil];
}


- (BOOL)update:(NSObject<SQLiteWritable>*)iBusinessObject withForeignKeys:(NSDictionary*)iFKeys
{
    NSString* aSQLValues = [iBusinessObject sqlValuesForUpdate];
    
    // Query building
	NSString* aQuery = [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE %@ = '%@'", 
						[iBusinessObject class],                        // CLASS
						aSQLValues,                                     // UPDATE VALUES
                        [[iBusinessObject class ] sqlColumnNameID],     // COLUMN ID NAME (ex wid)
                        [iBusinessObject sqlID]                         // COLUMN ID VALUE
						];
    
    return [self executeQuery:aQuery];
}

- (BOOL)update:(NSObject<SQLiteWritable>*)iBusinessObject
{
    return [self update:iBusinessObject withForeignKeys:nil];
}





@end
