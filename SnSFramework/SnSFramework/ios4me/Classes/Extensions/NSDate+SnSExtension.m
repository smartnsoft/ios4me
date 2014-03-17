//
//  NSDate+SnSExtension.m
//  ios4me
//
//  Created by Johan Attali on 13/04/12.
//  Copyright (c) 2012 Smart&Soft. All rights reserved.
//

#import "NSDate+SnSExtension.h"

@implementation NSDate (SnSExtension)

+ (NSDate *)dateMidnight
{
	NSDate* aDateNow = [NSDate date];
	
	NSDateComponents *components = [[NSCalendar currentCalendar] components:NSIntegerMax fromDate:aDateNow];
	[components setHour:0];
	[components setMinute:0];
	[components setSecond:0];
	
	NSDate *aDateMidnight = [[NSCalendar currentCalendar] dateFromComponents:components];
	
	return aDateMidnight;
	
}

- (NSDate *)dateMidnight
{
	NSDate* aDateNow = self;
	
	NSDateComponents *components = [[NSCalendar currentCalendar] components:NSIntegerMax fromDate:aDateNow];
	[components setHour:0];
	[components setMinute:0];
	[components setSecond:0];
	
	NSDate *aDateMidnight = [[NSCalendar currentCalendar] dateFromComponents:components];
	
	return aDateMidnight;
}

#pragma mark Parsing

- (id)initWithDictionary:(NSDictionary*)iDic key:(NSString*)iKey
{
	NSString* aDateStr = [iDic objectForKey:iKey];
	NSDate*	 aDate = nil;
	
	if ([aDateStr isKindOfClass:[NSNumber class]])
	{
		NSNumber* aDateNbr = (NSNumber*)aDateStr;
		NSTimeInterval aFactor = [[aDateNbr stringValue] length] > 10 ? 0.001 : 1.0;	// do not treat ms
		aDate = [NSDate dateWithTimeIntervalSince1970:[aDateStr doubleValue]*aFactor];
		
	}
	else if ([aDateStr isKindOfClass:[NSString class]] && aDateStr.length)
	{
		NSDateFormatter* fullFormat = [[NSDateFormatter alloc] init];
		[fullFormat setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] autorelease]];
		[fullFormat setDateFormat:@"EEE, dd MM yyyy HH:mm:ss zzzz"];
		
		NSDateFormatter* simpleFormat = [[NSDateFormatter alloc] init];
		[simpleFormat setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] autorelease]];
		[simpleFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
		
		NSDateFormatter* gmtFormat = [[NSDateFormatter alloc] init];
		[gmtFormat setLocale: [[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"] autorelease]];
		[gmtFormat setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
		[gmtFormat setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'+'02:00"]; // should Z but metro returns bad format
		
		aDate = [fullFormat dateFromString:aDateStr];
		
		if (aDate == nil)
			aDate = [simpleFormat dateFromString:aDateStr];
		
		if (aDate == nil)
			aDate = [gmtFormat dateFromString:aDateStr];
		
		
		// Release objects
		[fullFormat release];
		[simpleFormat release];
		[gmtFormat release];
	}
	
	// If init failed created a default date based on epoch time
	if (aDate == nil)
		aDate = [NSDate dateWithTimeIntervalSince1970:0];
	
	// Sicne we are calling a init method we expect a newly assigned object
	// hence a COPY signal on the calculated date
	return  [aDate copy];
}

- (id)initWithDictionary:(NSDictionary *)iDic key:(NSString *)iKey format:(NSString *)iFormat
{
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
	NSString *dateStr = [iDic objectForKey:iKey];
	NSDate *date = nil;
	
	if ([dateStr isKindOfClass:[NSString class]])
	{
		[formatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] autorelease]];
		[formatter setDateFormat:iFormat];
		date = [formatter dateFromString:dateStr];
	}
    
	return [date copy];
}


@end
