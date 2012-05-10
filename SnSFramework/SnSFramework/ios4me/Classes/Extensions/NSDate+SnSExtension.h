//
//  NSDate+SnSExtension.h
//  ios4me
//
//  Created by Johan Attali on 13/04/12.
//  Copyright (c) 2012 Smart&Soft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (SnSExtension)

+ (NSDate *)dateMidnight;
- (NSDate *)dateMidnight;

#pragma mark Object Methods

- (id)initWithDictionary:(NSDictionary*)iDic key:(NSString*)iKey;


@end
