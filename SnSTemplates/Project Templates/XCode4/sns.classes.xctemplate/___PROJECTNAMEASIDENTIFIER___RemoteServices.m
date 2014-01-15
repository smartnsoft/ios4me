//
//  ￼___FILENAME___
//  ___PROJECTNAMEASIDENTIFIER___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright ___YEAR___ ___ORGANIZATIONNAME___. All rights reserved.
//

#import "___FILEBASENAME___.h"

#import <ASIHTTPRequest/ASIDownloadCache.h>

// Categories
#import "JSON.h"

// Business Objects
#import "___PROJECTNAMEASIDENTIFIER___AbstractObject.h"

static const NSString* kRequestCodeKey = @"code";
static const NSString* kRequestCodeOk = @"ok";
static const NSString* kRequestContentKey = @"content";

@implementation ___FILEBASENAME___

#pragma mark -
#pragma mark Overriding Master Methods
#pragma mark -

- (NSURL *)urlForResizingServices:(NSURL *)iImageURL binding:(UIImageView *)iBindingView
{
	NSString* str = [NSString stringWithFormat:@"%@?w=%d&h=%d&c=0&drop=0&f=JPEG&cv=80&u=%@",
					 @"http://___FILEBASENAME___/",
					 (NSInteger)VIEW_WIDTH(iBindingView),
					 (NSInteger)VIEW_HEIGHT(iBindingView),
					 iImageURL];
	
	return [NSURL URLWithString:str];
}

#pragma mark -
#pragma mark Parsing Response
#pragma mark -

- (NSObject *)dictionaryResponseFromRequest:(ASIHTTPRequest *)iRequest
{
	id content = nil;
	NSError *error = [iRequest error];
	NSString* response = [iRequest responseString];
	NSDictionary* headers = [iRequest responseHeaders];
	
	SnSLogD(@"[%@] Response Headers: %@", [iRequest url], headers);
	
	// Handle Error
	if (error) 
		SnSLogE(@"[%@] Server Error =>%@", [iRequest url], [error description]);
	else
	{
		SnSLogD(@"[%@] Server Response [%d bytes] Did use cache [%d]", 
				[iRequest url], 
				[[iRequest responseData] length],
				[iRequest didUseCachedResponse]);
		
		NSString* contentType = [headers objectForKey:@"Content-Type"];
		
		// JSON
		if (contentType && [contentType rangeOfString:@"json"].location != NSNotFound)
			content = [self dictionaryResponseFromResponse:response];
		
		// In case of error
		if (!content)
		{
			SnSLogE(@"Failed to parse response of content type: %@ - url %@", contentType, [iRequest url]);
			
			[[ASIDownloadCache sharedCache] removeCachedDataForRequest:iRequest];
		}
		
	}
	
	
	return content;
}

- (NSObject *)dictionaryResponseFromResponse:(NSString *)iResponse
{
	id jsonParsed = nil;
	id content = nil;
	
	jsonParsed = [iResponse JSONValue];
	
	
	NSString* code = [jsonParsed objectForKey:kRequestCodeKey];
	if (![code isKindOfClass:[NSString class]] || 
		![code isEqualToString:(NSString*)kRequestCodeOk])
		SnSLogE(@"Failed to parse response : %@", iResponse);
	else
		content = [jsonParsed objectForKey:kRequestContentKey];
	
	return content;
	
	
}

- (id)contentFromJSONObject:(id)iJSONItems withClass:(Class)iClass
{
	id content = nil;
    
	// Array
	if ([iJSONItems isKindOfClass:[NSArray class]])
	{
		NSArray* items = (NSArray*)iJSONItems;
		
		content = [[[NSMutableArray alloc] initWithCapacity:[iJSONItems count]] autorelease];
		for (NSDictionary* item in items)
		{
			// Create BOM
			id aNewObj = [[iClass alloc] initWithJSONDictionary:item];
			
			// Add it to the returned list
			[content addObject:aNewObj];
			
			// Release already retained objects
			[aNewObj release];
		}
	}
	
	// Dictionary
	else if ([iJSONItems isKindOfClass:[NSDictionary class]])
	{
		NSDictionary* items = (NSDictionary*)iJSONItems;
		
		content = [[iClass alloc] initWithJSONDictionary:items];
	}
	
	return  content;
	
}

#pragma mark -
#pragma mark Working on Requests
#pragma mark -

- (ASIHTTPRequest *)defaultRequestFromURL:(NSURL *)iURL
{
	ASIHTTPRequest *request	= [ASIHTTPRequest requestWithURL:iURL];
	
    // Add the header param to be accepted by the resizing plateform
    NSString * bundleId = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    NSString * userAgent = [NSString stringWithFormat:@"%@|%@|%@",@"SnS Custom User Agent" , bundleId, bundleId, nil];
	
    [request setUserAgent:userAgent];
	
	return request;
}

- (void)processRequest:(ASIHTTPRequest *)iRequest 
	   completionBlock:(___PROJECTNAMEASIDENTIFIER___ServicesBlock)iBlock 
			  forClass:(Class)iClass
{
	// Name Queue
	NSString* name = [NSString stringWithFormat:@"%@ Retrieval", NSStringFromClass(iClass)];
	
	// Create the background queue
	dispatch_queue_t queue = dispatch_queue_create([name cStringUsingEncoding:NSUTF8StringEncoding], NULL);
	
	// Start work in new thread
	dispatch_async(queue, ^
				   {   
					   SnSLogD(@"[%@] - Starting Request", [iRequest url]);
					   
					   // The download can be synchrounous since GCD will be running this code
					   // in another thread
					   [iRequest startSynchronous];
					   
					   SnSLogD(@"[%@] - Ended Request", [iRequest url]);
					   
					   // Parse JSON
					   id json = [self dictionaryResponseFromRequest:iRequest];
					   
					   // JSON -> Business Objects
					   id content = [self contentFromJSONObject:json withClass:iClass];
					   
					   // Process is done, call the completion block in the main thread
					   dispatch_async(dispatch_get_main_queue(), ^{
						   iBlock(content);
					   });
				   });
	
	// won’t actually go away until queue is empty
	dispatch_release(queue);  
	
}

- (void)processTestFile:(NSString *)iFileName 
		completionBlock:(___PROJECTNAMEASIDENTIFIER___ServicesBlock)iBlock
			   forClass:(Class)iClass
{
	// Name Queue
	NSString* name = [NSString stringWithFormat:@"%@ Retrieval", NSStringFromClass(iClass)];
	
	// Create the background queue
	dispatch_queue_t queue = dispatch_queue_create([name cStringUsingEncoding:NSUTF8StringEncoding], NULL);
	
	// Start work in new thread
	dispatch_async(queue, ^
				   {   
					   @synchronized(self)
					   {
						   SnSLogD(@"[%@] - Reading File", iFileName);
						   
						   // The download can be synchrounous since GCD will be running this code
						   // in another thread
						   NSString* path = [[NSBundle mainBundle] pathForResource:iFileName ofType:@"json"];
						   NSError* error = nil;
						   NSString* str = [NSString stringWithContentsOfFile:path
																	 encoding:NSUTF8StringEncoding
																		error:&error];
						   
						   SnSLogD(@"[%@] - Ended Reading", iFileName);
						   
						   // Parse JSON
						   id json = [self dictionaryResponseFromResponse:str];
						   
						   // JSON -> Business Objects
						   id content = [self contentFromJSONObject:json withClass:iClass];
						   
						   // Process is done, call the completion block in the main thread
						   dispatch_async(dispatch_get_main_queue(), ^{
							   iBlock(content);
						   });
					   }
				   });
	
	// won’t actually go away until queue is empty
	dispatch_release(queue); 
}

@end








