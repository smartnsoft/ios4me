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


#import <sqlite3.h>

#import "SnSSingleton.h"
#import "SnSSQLiteStorable.h"

@interface SnSSQLiteAccessor : SnSSingleton
{
	NSInteger _lastInsertedRowID; 
}

// This property is shared by all accessors so it's ok to have it in the same instance
@property (readonly) NSInteger lastInsertedRowID;  

#pragma mark Phyisical DB Actions Related 

/**
 *  For first time launch of the application the local sqlite database
 *  needs to be put to the application document folder
 * @result
 *  True if the reset was correctly processed.
 */
- (Boolean)createDatabaseIfNeeded;

/**	
 *  Everytime the database is changed you must update this part of the code
 *	to test if a patch needs to be applied and apply it if needed
 * @result
 *  True if the database needed to be patched
 */
- (Boolean)patchDatabaseIfNeeded;

/**
 *	Restores original database with default settings by copying
 *	the sqlite3 database located in Resources into the application directory
 * @result
 *  True if the reset was correctly processed.
 */
- (Boolean)resetDatabase;


/**
 *	Removes the database from the filesystem
 * @result
 *  True if the action was correctly processed.
 */
- (Boolean)removeDatabase;

/**
 * Returns the exact path where the local sqlite db is located 
 * That is the databasePath + databaseName
 * @result A string with the corresponding path
 */
- (NSString*)databaseFullPath;


/**
 * Returns the exact path where the local sqlite 
 * database will be stored. (This path is set once and for when the user downloads an application)
 * @result A string with the corresponding path
 */
- (NSString*)databasePath;

/**
 *	Your master accessor should override this method to set the current databasename
 *	of your application. ex. "my_database.db"
 * @result		
 *  A string with the database name
 */
- (NSString*)databaseName;

#pragma mark Preperation

/**
 *	Returns the statement located into SELECT or INSERT queries
 *	and will vary depending on the subclass called
 * @result
 *  An autoreleased string object
 */
- (NSString*) preparationStatement;

/**
 *	Returns part of the statement that will be used for insertion
 * @param iBusinessObjectClass
 *	The class for the object to be inserted
 * @result
 *  A coma separated list of strings that will be inserted 
 */
- (NSString*) preparationForInsert:(Class)iBusinessObjectClass;

/**
 *	Returns part of the statement that will be used for selection
 * @param iBusinessObjectClass
 *	The class for the object to be selected
 * @result
 *  A coma separated list of strings that will be selected 
 */
- (NSString*) preparationForSelect:(Class)iBusinessObjectClass;

#pragma mark Execution 

/**
 *	Runs a SELECT last_insert_rowid() and returns the result
 *  Please note that running this if mutiple threads are inserting at the 
 *  same time is useless as it can't be trusted.
 * @result
 *  The result of the SELECT last_insert_rowid().
 *  0 means query insertion most likely failed.
 */
- (NSInteger)lastInsertRowID:(sqlite3*)pDatabase;

/**
 *	Creates the sqlite statement and does the sqlite3 call 
 *  to retreive elements with more than one matching element.
 * @param iQuery
 *  The string that holding the query 
 * @param iClass
 *  The object class that will be used during the array construction 
 * @result
 *  An array built from matching objects
 */
- (NSArray*)arrayOfObjectsFromQuery:(NSString*)iQuery object:(Class<SQLiteReadable>)iClass;

/**
 *	Creates and executes a query of type:
 *	SELECT * FROM iClass WHERE mainIDColumName = iObjectID 
 * @param iObjectID
 *  The value of the id as it should be found in the database
 * @param iClass
 *  The object class that will be used during the array construction 
 * @result
 *  The object initalized if found or nil otherwise
 */
- (NSObject<SQLiteReadable>*)businessObjectFromID:(NSString*)iObjectID object:(Class<SQLiteReadable>)iClass;

/**
 *	Execute the given query and returns the last statement result
 * @param iQuery
 *  The string that holding the query (ex. select * from table)
 * @result		
 *  true if correctly processed. false otherwise
 */
- (BOOL)executeQuery:(NSString*)iQuery;




#pragma mark INSERT/UPDATE/DELETE 

/**
 *	Creates and executes a query of type:
 *	DELETE FROM iBusinessObject.class WHERE mainIDColumName = iBusinessObject.id
 * @param iBusinessObject
 *  The object to be deleted from database
 * @result		
 *  true if correctly processed. false otherwise
 */
- (BOOL)deleteBusinessObject:(NSObject<SQLiteReadable>*)iBusinessObject;

/**
 *	Delete All elements from the given class
 * @param iClass
 *  The object class that will be used during the array construction 
 * @result
 *  The object initalized if found or nil otherwise
 */
- (BOOL)deleteAllFromTable:(Class<SQLiteWritable>)iClass;

/**
 *	Saves the object passed in parameter into the database.
 *	Saving means 
 *		1. Updating if business object is already stored<
 *		2. Inserting if business object is not already stored in local db
 * @param iBusinessObject
 *  The business object to store into the database
 *	This object should respond to both Writable and Readable protocol because a
 *	query is made before to see if insertion is required.
 * @result		
 *  true if correctly processed. false otherwise
 * @see
 *	insert:
 *	update:
 */
- (BOOL)save:(NSObject<SQLiteWritable,SQLiteReadable>*)iBusinessObject;

/**
 *	Saves the object passed in parameter into the database.
 *	Saving means 
 *		1. Updating if business object is already stored<
 *		2. Inserting if business object is not already stored in local db
 * @param iBusinessObject
 *  The business object to store into the database
 *	This object should respond to both Writable and Readable protocol because a
 *	query is made before to see if insertion is required.
 * @param iFKeys
 *  The hash map of foreign key to refer to (Key -> Value)
 * @result		
 *  true if correctly processed. false otherwise
 * @see
 *	insert:
 *	update:
 */
- (BOOL)save:(NSObject<SQLiteWritable,SQLiteReadable>*)iBusinessObject withForeignKeys:(NSDictionary*)iFKeys;


/**
 *	The insert method only adds objects it doesn't update them.
 * @param iBusinessObject
 *  The business object to store into the database
 * @result		
 *  true if correctly processed. false otherwise
 * @see
 *	save:
 *	update:
 */
- (BOOL)insert:(NSObject<SQLiteWritable>*)iBusinessObject;

/**
 *	The insert method only adds objects it doesn't update them.
 * @param iBusinessObject
 *  The business object to store into the database
 * @param iFKeys
 *  The hash map of foreign key to refer to (Key -> Value)
 * @result		
 *  true if correctly processed. false otherwise
 * @see
 *	insert:
 */
- (BOOL)insert:(NSObject<SQLiteWritable>*)iBusinessObject withForeignKeys:(NSDictionary*)iFKeys;

/**
 *	The udpate method doesn't insert any new objects it only udpates an existing one.
 * @param iBusinessObject
 *  The business object to store into the database
 * @result		
 *  true if correctly processed. false otherwise
 * @see
 *	save:
 *	insert:
 */
- (BOOL)update:(NSObject<SQLiteWritable>*)iBusinessObject;

/**
 *	The udpate method doesn't insert any new objects it only udpates an existing one.
 * @param iBusinessObject
 *  The business object to store into the database
 * @param iFKeys
 *  The hash map of foreign key to refer to (Key -> Value)
 * @result		
 *  true if correctly processed. false otherwise
 * @see
 *	save:
 *	insert:
 */
- (BOOL)update:(NSObject<SQLiteWritable>*)iBusinessObject withForeignKeys:(NSDictionary*)iFKeys;


#pragma mark Execution Status

/*!
 * @method		
 *  queryFailed:
 * @abstract	
 *  Treats a query that failed to execute by, for example, printing an error message.
 *	TODO: Put this into a @protocol
 * @param iQuery
 *  The query that failed to execte
 * @param iParameter
 *  Anything related to the query that could be useful to display
 */
- (void)didFailToExecute:(NSString*)iQuery parameter:(id)iParameter;

/*!
 * @method		
 *  queryFailed:
 * @abstract	
 *  Treats a query that was executed successfully to execute by, for example, printing an a sucess message.
 *	TODO: Put this into a @protocol
 * @param iQuery
 *  The query that failed to execte
 * @param iParameter
 *  Anything related to the query that could be useful to display
 */
- (void)didSucceedToExecute:(NSString*)iQuery parameter:(id)iParameter;

/*!
 * @method		
 *  sqlInformatiomFromCode:
 * @abstract	
 *  ex. a Query returns SQLITE_MISMATCH, the purpose of this function to give the correct
 *	string useful to pop as a log.
 * @param iErrorCode
 *  The error Code ex. SQLITE_MISMATCH
 * @result
 *	ex. SQLITE_MISMATCH -> @" SQLITE_MISMATCH      (Data type mismatch)"
 */
- (NSString*)sqlInformatiomFromCode:(NSInteger)iErrorCode;


@end
