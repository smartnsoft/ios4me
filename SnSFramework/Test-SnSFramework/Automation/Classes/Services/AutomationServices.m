//
//  LnBServices.m
//  LooknBe
//
//  Created by «FULLUSERNAME» on «DATE».
//  Copyright «YEAR» «ORGANIZATIONNAME». All rights reserved.
//  Created by ApplicationAuthor on ApplicationCreationDate.
//

#import "AutomationServices.h"

#define isBouchon NO

#pragma mark -
#pragma mark AutomationException

@implementation AutomationException

@synthesize cause;

+ (void) raise:(NSError *)error
{
  @throw [[AutomationException alloc] initWithError:error];
}

- (id) initWithError:(NSError *)error
{
  if (![super initWithName:[error domain] reason:[[error userInfo] objectForKey:@"NSLocalizedDescription"] userInfo:[error userInfo]])
  {
    return nil;
  }
  cause = [error retain];
  return self;
}

@end

#pragma mark -
#pragma mark AutomationServices(Private)

@interface AutomationServices(Private)

- (NSString *) appendCommonParams:(NSString *)params;
- (NSData *) callHttpRequest:(NSURLRequest *)urlRequest;

@end

@implementation AutomationServices(Private)

- (NSString *) appendCommonParams:(NSString *)params
{
	NSString *languageCode = [[NSLocale currentLocale] objectForKey: NSLocaleLanguageCode];
	NSString * countryCode = [[NSLocale currentLocale] objectForKey: NSLocaleCountryCode];
	languageCode = [NSString stringWithFormat:@"%@_%@",languageCode,countryCode];
	return [NSString stringWithFormat:@"lang=%@%@", languageCode, params];
	
}

/**
 * Classical HTTP Request.
 **/
- (NSData *) callHttpRequest:(NSURLRequest *)urlRequest
{
	NSError * error = nil;
	NSHTTPURLResponse * urlResponse = nil;
	NSData * data = nil;
	data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&urlResponse error:&error];
	if (error != nil)
	{
		SnSLogE(@"Error while retrieving the data regarding the URL '%@'", [[urlRequest URL] absoluteString]);
		[AutomationException raise:@"Server problem" format:SnSLocalized(@"NoInternetConnection") , nil];
	}
	else if ([urlResponse statusCode] != 200)
	{
		SnSLogI(@"Response from server with status code %i corresponding to the URL '%@'", [urlResponse statusCode], [[urlRequest URL] absoluteString]);
		NSString * errorName = (data == nil ? @"Bad response from server" : [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
		@throw [[AutomationException alloc] initWithName:errorName reason:[NSString stringWithFormat:@"Status code: %i", [urlResponse statusCode]] userInfo:nil];
	}
	else if (data == nil)
	{
		SnSLogI(@"There are no data regarding the URL '%@'", [[urlRequest URL] absoluteString]);
	  [AutomationException raise:@"Server problem" format:SnSLocalized(@"NoInternetConnection") , nil];
  }
	return data;
}

@end

#pragma mark -
#pragma mark AutomationServices

@implementation AutomationServices

+ (AutomationServices *) instance
{  
  static AutomationServices * _instance;
  @synchronized (self)
  {
    if (_instance == NULL)
    {
      _instance = [[self alloc] init];
    }
  }
  return _instance;
}

- (id) init
{
  SnSLogI(@"Initializing the AutomationServices services");
  if (![super init])
  {
    return nil;
  }
  return self;
}

/**
 * General parsing of result
 **/
- (NSDictionary *) getResultFromResponse:(NSDictionary *)jsonResponse
{
  if ([jsonResponse objectForKey:@"errors"] != nil && !((NSNull *)[jsonResponse objectForKey:@"errors"] == [NSNull null]))
  {
    NSArray * errors = [jsonResponse objectForKey:@"errors"];
    if ([errors count] > 0) 
    {
      [AutomationException raise:@"Service problem" format:[errors objectAtIndex:0] , nil];
    }
  }
	return (NSDictionary *)[jsonResponse objectForKey:@"resultat"];
}

/******************** APNS Services ***************************/

- (void) updateUser:(NSString *)userUDID andToken:(NSString *)apnsToken
{
  // TODO : to be completed by the call on server to save user information to Push Notification Service
  
}

@end
