/* 
 * Copyright (C) 2009 Smart&Soft.
 * All rights reserved.
 *
 * The code hereby is the full property of Smart&Soft, SIREN 517 961 744.
 * http://www.smartnsoft.com - contact@smartnsoft.com
 * 
 * You are not allowed to use the source code or the resulting binary code, nor to modify the source code, without prior permission of the owner.
 *
 * This library is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 */

//
//  SnSWebServiceCaller.m
//  SnSFramework
//
//  Created by Édouard Mercier on 23/12/2009.
//

#import "SnSWebServiceCaller.h"

#pragma mark -
#pragma mark SnSCallException

@implementation SnSCallException

@end

#pragma mark -
#pragma mark SnSWebServiceCaller

@implementation SnSWebServiceCaller

- (NSString *) computeUri:(NSString *)methodUriPrefix methodUriSuffix:(NSString *)methodUriSuffix
{
  return [self computeUri:methodUriPrefix methodUriSuffix:methodUriSuffix uriParameters:nil];
}

- (NSString *) computeUri:(NSString *)methodUriPrefix methodUriSuffix:(NSString *)methodUriSuffix uriParameters:(NSDictionary *)uriParameters
{
  NSMutableString * uri = [NSMutableString stringWithString:methodUriPrefix];
  if (methodUriSuffix != nil && [methodUriSuffix length] > 0)
  {
    [uri appendFormat:@"/%@", methodUriSuffix];
  }
  NSEnumerator * enumerator = [uriParameters keyEnumerator];
  NSString * key;
  BOOL first = YES;
  while (key = [enumerator nextObject])
  {
    if (first == YES)
    {
      [uri appendFormat:@"?"];
      first = NO;
    }
    else
    {
      [uri appendFormat:@"&"];      
    }
    [uri appendFormat:@"%@=%@", key, [uriParameters objectForKey:key]];
  }
  return uri;
}

@end
