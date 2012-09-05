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

@end
