//
//  ButtonWithImage.h
//  dismoiou
//
//  Created by Romain on 28/10/10.
//  Copyright 2010 Badtech. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ButtonWithImage : UIView 
{
    UIButton *button;
    UILabel *label;  
}


- (id)initWithFrame:(CGRect)frame image:(NSString*)imgName legend:(NSString*)legend;
- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

@end
