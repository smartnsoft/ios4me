//
//  NSString+SnSExtension.m
//  SnSFramework
//
//  Created by Johan Attali on 8/4/11.
//  Copyright 2011 Smart&Soft. All rights reserved.
//

#import "NSString+SnSExtension.h"
#import "CommonCrypto/CommonDigest.h"

@implementation NSString (SnSExtensionPrivate)

#pragma mark -
#pragma mark Class Methods
#pragma mark -

+ (NSString*) stringUnique
{
	CFUUIDRef newUniqueId = CFUUIDCreate(kCFAllocatorDefault);
	CFStringRef newUniqueIdString = CFUUIDCreateString(kCFAllocatorDefault, newUniqueId);
	
	NSString* aUniqueString = [NSString stringWithString:(NSString *)newUniqueIdString];
	
	CFRelease(newUniqueId);
	CFRelease(newUniqueIdString);
	
	return aUniqueString;
}

+ (NSInteger)integerFromStatement:(sqlite3_stmt*)iStatement column:(NSInteger)iColumn
{
    NSInteger aRes = NSIntegerMin;
	if (sqlite3_column_type(iStatement, iColumn) == SQLITE_INTEGER)
		aRes = (NSInteger)sqlite3_column_int(iStatement, iColumn);
	return aRes;
}

+ (NSInteger)integerFromDictionary:(NSDictionary*)iDict key:(NSString*)iKey
{
	
	NSInteger aRes = NSIntegerMin;
	NSString* aValue = [iDict objectForKey:iKey];
	
	if ([aValue isKindOfClass:[NSString class]])
		aRes  = [[aValue stringByStrippingNonNumbers] integerValue];
	else if ([aValue isKindOfClass:[NSNumber class]])
		aRes = [aValue integerValue];
	
	return aRes;
	
}

#pragma mark -
#pragma mark Hashing
#pragma mark -

- (NSString *)md5
{
	const char *cStr = [self UTF8String];
	unsigned char digest[16];
	CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
	
	NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
	
	for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
		[output appendFormat:@"%02x", digest[i]];
	
	return  output;
}

- (NSString *)sha1
{
	const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
	NSData *data = [NSData dataWithBytes:cstr length:self.length];
	
	uint8_t digest[CC_SHA1_DIGEST_LENGTH];
	
	CC_SHA1(data.bytes, data.length, digest);
	
	NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
	
	for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
		[output appendFormat:@"%02x", digest[i]];
	
	return output;
}

#pragma mark -
#pragma mark Object Methods
#pragma mark -

#pragma mark - Init Methods

- (id)initWithSQLiteStatement:(sqlite3_stmt*)iStatement column:(NSInteger)iColumn
{
    const unsigned char* t = sqlite3_column_text(iStatement, iColumn);
	
	self = nil;
	if (t)
		self =  [[NSString alloc] initWithCString:(const char*)sqlite3_column_text(iStatement, iColumn)
										 encoding:NSUTF8StringEncoding];
	return self;
}

- (id)initWithDictionary:(NSDictionary *)iDic key:(NSString *)iKey
{
	if ([iDic isKindOfClass:[NSDictionary class]])
	{
		NSString* aValue = [iDic objectForKey:iKey];		
		
		if ([aValue isKindOfClass:[NSString class]])
		{
			aValue = [aValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
			self = [self initWithString:aValue];
		}
		else if ([aValue isKindOfClass:[NSNumber class]])
			self = [self initWithFormat:@"%@", aValue];
		else
			self = [self initWithString:@""];

	}
	else
		self = [self initWithString:@""];
		
	return self;
}


#pragma mark - Stripping / Joining

- (NSString *)stringByStrippingHTML 
{
	NSRange r;
	NSString *s = [[self copy] autorelease];
	while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
		s = [s stringByReplacingCharactersInRange:r withString:@""];
	return s;
}

- (NSString*) stringByEscapingSingleQuotesForSQLite
{
    // Quoting in SQLite means adding one more quote an existing one
    return [self stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
}


- (NSString*) stringByJoiningArray:(NSArray*)iArray
{
    NSString* aJoinedString = @"";
    NSInteger aMax = [iArray count];
    
    for (NSInteger aIndex = 0; aIndex < aMax; ++aIndex) 
    {
        aJoinedString = [aJoinedString stringByAppendingFormat:@"%@%@",
                         [[iArray objectAtIndex:aIndex] description],   // Object Value
                         aIndex < aMax - 1 ? self :  @""                // join with self if end not reached
                         ];
    }
    
    return aJoinedString;
}

- (NSString*) stringByStrippingNonNumbers
{
    NSMutableString *aStrippedString = [NSMutableString stringWithCapacity:self.length];
    
    NSScanner *aScanner         = [NSScanner scannerWithString:self];
    NSCharacterSet *aNumberSet  = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    
    while ([aScanner isAtEnd] == NO)
    {
        NSString *aBuffer;
        if ([aScanner scanCharactersFromSet:aNumberSet intoString:&aBuffer])
            [aStrippedString appendString:aBuffer];
		
        else
            [aScanner setScanLocation:([aScanner scanLocation] + 1)];
    }
    
    return [NSString stringWithString:aStrippedString];
}

- (NSString*) stringByStrippingNumbers
{
    NSMutableString *strippedStr = [NSMutableString stringWithCapacity:self.length];
    
    NSScanner *scanner         = [NSScanner scannerWithString:self];
    NSCharacterSet *numbers  = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    
    while ([scanner isAtEnd] == NO)
    {
        NSString *str;
        if ([scanner scanUpToCharactersFromSet:numbers intoString:&str])
            [strippedStr appendString:str];
		else
			[scanner setScanLocation:([scanner scanLocation] + 1)];
    }
    
    return [NSString stringWithString:strippedStr];
}


@end
