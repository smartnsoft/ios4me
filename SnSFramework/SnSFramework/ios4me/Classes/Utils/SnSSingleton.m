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
    id _sharedInstance = nil;
    static id _sharedInstances = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedInstances = [[NSMutableDictionary alloc] init];
    });
    
    @synchronized(self)
    {
        if ((_sharedInstance = [_sharedInstances objectForKey:NSStringFromClass([self class])]) == nil)
        {
            _sharedInstance = [[self alloc] init];
            [_sharedInstances setObject:_sharedInstance forKey:NSStringFromClass([self class])];
            
            [_sharedInstance setup];
            [_sharedInstance release]; // already retained by _sharedInstances
        }
    }
    
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
