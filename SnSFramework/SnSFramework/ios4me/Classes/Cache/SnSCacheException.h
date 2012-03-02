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

NSString *const SnSCacheErrorDomain;
NSString *const SnSCacheExceptionName;

typedef enum SnSCacheErrorType
{
	SnSCacheErrorKeysClassNotMatch = 0,
	SnSCacheErrorCacheNotFound,
	SnSCacheErrorTooManySilosFound,
	
	/* Cache URL */
	SnSCacheErrorURLExpected,
	SnSCacheErrorURLRequestFailed,
	
	/* Cache Archive/Unarchive */
	SnSCacheErrorArchiveFailed,
	SnSCacheErrorUnarchiveFailed,
	SnSCacheErrorLoadFailed,
	
	/* Cache Creation/Deletion */
	SnSCacheErrorCacheCreateFailed,
	SnSCacheErrorCacheDeleteFailed,
}SnSCacheErrorType;



@interface SnSCacheError : NSError 
{
	NSString* _reason;
}
@property (nonatomic, readonly) NSString* reason;
/**
 * This becomes the designated initalizer for SnSErrors
 */
+ (id)errorWithCode:(SnSCacheErrorType)iCode userInfo:(NSDictionary*)iUserInfo;
- (id)initWithCode:(SnSCacheErrorType)iCode userInfo:(NSDictionary*)iUserInfo;

+ (id)errorWithCode:(SnSCacheErrorType)iCode localizedDescription:(NSString*)iDescription;
- (id)initWithCode:(SnSCacheErrorType)iCode localizedDescription:(NSString*)iDescription;

- (NSString*)extraInformationFromCode:(SnSCacheErrorType)iCode;
@end
/**
 * An exception which may be thrown by the SnSURLCache methods.
 */
@interface SnSCacheException : NSException
{
	//SnSCacheExceptionType _type;
}

+ (id)exceptionWithError:(SnSCacheError*)iError;
- (id)initWithError:(SnSCacheError*)iError;


//@property(nonatomic, readonly) SnSCacheExceptionType type; //!< The cause of the exception: may be <code>nil</code>

///**
// *	Creates an instance of SnSCacheException from a given error type
// */
//
//- (SnSCacheException*) initWithType:(SnSCacheExceptionType)iType;
//+ (SnSCacheException*) exceptionWithType:(SnSCacheExceptionType)iType;
//
///**
// *	@param	iType	The type of exeption beign raised
// *	@param	iParam	A param used to build the exception
// *	@return The string explaining the exception from its type
// */
//- (NSString*)reasonFromType:(SnSCacheExceptionType)iType param:(id)iParam error:(NSError*)iError;
//- (NSString*)reasonFromType:(SnSCacheExceptionType)iType param:(id)iParam;
//- (NSString*)reasonFromType:(SnSCacheExceptionType)iType;


@end
