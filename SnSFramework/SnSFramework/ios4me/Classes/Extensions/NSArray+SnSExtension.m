//
//  NSArray+SnSExtension.m
//  ios4me
//
//  Created by Johan Attali on 28/05/12.
//  Copyright (c) 2012 Smart&Soft. All rights reserved.
//

#import "NSArray+SnSExtension.h"

@implementation NSArray (SnSExtension)

- (id)firstObject
{
	if ([self count] > 0)
		return [self objectAtIndex:0];
	else
		return nil;
}

@end
