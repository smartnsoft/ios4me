//
//  NSArray+SnSExtension.h
//  ios4me
//
//  Created by Johan Attali on 28/05/12.
//  Copyright (c) 2012 Smart&Soft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (SnSExtension)

- (id)firstObject;
- (void)makeObjectsPerformBlock:(void (^)(id))block;

@end
