//
//  NSString+SnSExtension.m
//  SnSFramework
//
//  Created by Johan Attali on 8/4/11.
//  Copyright 2011 Smart&Soft. All rights reserved.
//

#import "NSString+SnSExtension.h"

@implementation NSString (SnSExtensionPrivate)

+ (NSString*) stringUnique
{
	CFUUIDRef newUniqueId = CFUUIDCreate(kCFAllocatorDefault);
	CFStringRef newUniqueIdString = CFUUIDCreateString(kCFAllocatorDefault, newUniqueId);
	
	NSString* aUniqueString = [NSString stringWithString:(NSString *)newUniqueIdString];
	
	CFRelease(newUniqueId);
	CFRelease(newUniqueIdString);
	
	return aUniqueString;
}

- (NSString*) stringByEscapingSingleQuotesForSQLite
{
    // Quoting in SQLite means adding one more quote an existing one
    return [self stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
}

- (NSString *)initWithSQLiteStatement:(sqlite3_stmt*)iStatement column:(NSInteger)iColumn
{
    const unsigned char* t = sqlite3_column_text(iStatement, iColumn);
	
	self = nil;
	if (t)
		self =  [[NSString alloc] initWithCString:(const char*)sqlite3_column_text(iStatement, iColumn)
										 encoding:NSUTF8StringEncoding];
	return self;
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
	
	if ([aValue isKindOfClass:[NSString class]] || [aValue isKindOfClass:[NSNumber class]])
		aRes  = [aValue integerValue];
	
	return aRes;
	
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


@end
