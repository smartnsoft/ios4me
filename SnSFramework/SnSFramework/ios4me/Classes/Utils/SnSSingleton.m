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
//  SnSSingleton.m
//  SnSFramework
//
//  Created by Johan Attali on 26/07/11.
//  Copyright 2011 Smart&Soft. All rights reserved.
//

#import "SnSSingleton.h"

@implementation SnSSingleton

+ (instancetype)instance
{
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
        [_sharedInstance setup];
    });
    
    return _sharedInstance;
}

- (void)setup
{
    // do nothing, let the children singleton process their first init there
}

- (void)reset
{
    return ; // Kept for legacy, i don't see a point in singleton reset.
}

@end
