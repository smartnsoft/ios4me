//
//  SnSSingleton.h
//  SnSFramework
//
//  Created by Johan Attali on 26/07/11.
//  Copyright 2011 Smart&Soft. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SnSSingleton : NSObject { }

+ (id)instance;
- (void)reset;
@end
