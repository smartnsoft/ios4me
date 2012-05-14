//
//  LnBServices.m
//  LooknBe
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright ___YEAR___ ___ORGANIZATIONNAME___. All rights reserved.
//

#import "___PROJECTNAMEASIDENTIFIER___Services.h"

#define isBouchon NO

#pragma mark -
#pragma mark ___PROJECTNAMEASIDENTIFIER___Exception

@implementation ___PROJECTNAMEASIDENTIFIER___Exception

@synthesize cause;

+ (void) raise:(NSError *)error
{
  @throw [[___PROJECTNAMEASIDENTIFIER___Exception alloc] initWithError:error];
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
#pragma mark ___PROJECTNAMEASIDENTIFIER___Services(Private)

@interface ___PROJECTNAMEASIDENTIFIER___Services(Private)

- (NSString *) appendCommonParams:(NSString *)params;
- (NSData *) callHttpRequest:(NSURLRequest *)urlRequest;

@end

@implementation ___PROJECTNAMEASIDENTIFIER___Services(Private)

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
		[___PROJECTNAMEASIDENTIFIER___Exception raise:@"Server problem" format:SnSLocalized(@"NoInternetConnection") , nil];
	}
	else if ([urlResponse statusCode] != 200)
	{
		SnSLogI(@"Response from server with status code %i corresponding to the URL '%@'", [urlResponse statusCode], [[urlRequest URL] absoluteString]);
		NSString * errorName = (data == nil ? @"Bad response from server" : [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
		@throw [[___PROJECTNAMEASIDENTIFIER___Exception alloc] initWithName:errorName reason:[NSString stringWithFormat:@"Status code: %i", [urlResponse statusCode]] userInfo:nil];
	}
	else if (data == nil)
	{
		SnSLogI(@"There are no data regarding the URL '%@'", [[urlRequest URL] absoluteString]);
	  [___PROJECTNAMEASIDENTIFIER___Exception raise:@"Server problem" format:SnSLocalized(@"NoInternetConnection") , nil];
  }
	return data;
}

@end

#pragma mark -
#pragma mark ___PROJECTNAMEASIDENTIFIER___Services

@implementation ___PROJECTNAMEASIDENTIFIER___Services

+ (___PROJECTNAMEASIDENTIFIER___Services *) instance
{  
  static ___PROJECTNAMEASIDENTIFIER___Services * _instance;
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
  SnSLogI(@"Initializing the ___PROJECTNAMEASIDENTIFIER___Services services");
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
      [___PROJECTNAMEASIDENTIFIER___Exception raise:@"Service problem" format:[errors objectAtIndex:0] , nil];
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
