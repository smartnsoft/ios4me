//
//  AutomationUtils.h
//  Automation
//
//  Created by Johan Attali on «DATE».
//  Copyright 2012 Smart&Soft. All rights reserved.
//  Created by ApplicationAuthor on ApplicationCreationDate.
//

#import <Foundation/Foundation.h>


@interface AutomationUtils : NSObject {

}

+ (UIButton *) initButton:(CGRect)frame withTarget:(id)target withAction:(SEL)sel withImage:(UIImage *)imgBackground withImagePressed:(UIImage *)imgBackgroundPressed fusionImage:(BOOL)fusion;

@end
