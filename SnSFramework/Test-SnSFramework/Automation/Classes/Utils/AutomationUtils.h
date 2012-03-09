//
//  AutomationUtils.h
//  Automation
//
//  Created by «FULLUSERNAME» on «DATE».
//  Copyright «YEAR» «ORGANIZATIONNAME». All rights reserved.
//  Created by ApplicationAuthor on ApplicationCreationDate.
//

#import <Foundation/Foundation.h>


@interface AutomationUtils : NSObject {

}

+ (UIButton *) initButton:(CGRect)frame withTarget:(id)target withAction:(SEL)sel withImage:(UIImage *)imgBackground withImagePressed:(UIImage *)imgBackgroundPressed fusionImage:(BOOL)fusion;

@end
