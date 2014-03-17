//
//  NSDictionary+SnSExtension.h
//  ios4me
//
//  Created by Johan Attali on 8/31/12.
//  Copyright (c) 2012 Smart&Soft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (SnSExtension)

- (NSString*)serializeForURL:(NSString *)baseUrl;
- (void)makeObjectsPerformBlock:(void (^)(id,id))block;

+ (NSDictionary *)dictionaryWithFormEncodedString:(NSString *)encodedString;

@end
