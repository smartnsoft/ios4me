//
//  NSDictionary+SnSExtension.m
//  ios4me
//
//  Created by Johan Attali on 8/31/12.
//  Copyright (c) 2012 Smart&Soft. All rights reserved.
//

#import "NSDictionary+SnSExtension.h"

@implementation NSDictionary (SnSExtension)

- (NSString*)serializeForURL:(NSString *)baseUrl
{
	NSURL* parsedURL = [NSURL URLWithString:baseUrl];
	NSString* queryPrefix = parsedURL.query ? @"&" : @"?";
	
	NSMutableArray* pairs = [NSMutableArray array];
	for (NSString* key in [self keyEnumerator])
	{
		CFStringRef ref = CFURLCreateStringByAddingPercentEscapes(
																  NULL, /* allocator */
																  (CFStringRef)[self objectForKey:key],
																  NULL, /* charactersToLeaveUnescaped */
																  (CFStringRef)@"!*'();:@&=+$,/?%#",
																  kCFStringEncodingUTF8);
		NSString* escaped_value = (NSString *)ref;
		
		[pairs addObject:[NSString stringWithFormat:@"%@=%@", key, escaped_value]];
		[escaped_value release];
	}
	NSString* query = [pairs componentsJoinedByString:@"&"];
	
	return [NSString stringWithFormat:@"%@%@%@", baseUrl, queryPrefix, query];
}


- (void)makeObjectsPerformBlock:(void (^)(id,id))block
{
    for (id key in [self allKeys])
        block(key, [self objectForKey:key]);
}

#pragma NSDictionary (NSURLQuery)

+ (NSDictionary *)dictionaryWithFormEncodedString:(NSString *)encodedString {
	if (!encodedString) {
		return nil;
	}
	
	NSMutableDictionary *result = [NSMutableDictionary dictionary];
	NSArray *pairs = [encodedString componentsSeparatedByString:@"&"];
	
	for (NSString *kvp in pairs) {
		if ([kvp length] == 0) {
			continue;
		}
		
		NSRange pos = [kvp rangeOfString:@"="];
		NSString *key;
		NSString *val;
		
		if (pos.location == NSNotFound) {
			key = [kvp stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
			val = @"";
		} else {
			key = [[kvp substringToIndex:pos.location] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
			val = [[kvp substringFromIndex:pos.location + pos.length] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		}
		
		if (!key || !val) {
			continue; // I'm sure this will bite my arse one day
		}
		
		[result setObject:val forKey:key];
	}
	return result;
}

@end
