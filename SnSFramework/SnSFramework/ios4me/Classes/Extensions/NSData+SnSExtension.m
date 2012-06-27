//
//  NSData+SnSExtension.m
//  ios4me
//
//  Created by Johan Attali on 27/06/12.
//  Copyright (c) 2012 Smart&Soft. All rights reserved.
//

#import "NSData+SnSExtension.h"

@implementation NSData (SnSExtension)

- (BOOL)isJPG
{
	if (self.length > 4)
	{
		unsigned char buffer[4];
		[self getBytes:&buffer length:4];
		
		return buffer[0]==0xff && buffer[1]==0xd8 && buffer[2]==0xff && buffer[3]==0xe0;
	}
	
	return NO;
}

- (BOOL)isPNG
{
	if (self.length > 4)
	{
		unsigned char buffer[4];
		[self getBytes:&buffer length:4];
		
		return buffer[0]==0x89 && buffer[1]==0x50 && buffer[2]==0x4e && buffer[3]==0x47;
	}
	
	return NO;
}

@end
