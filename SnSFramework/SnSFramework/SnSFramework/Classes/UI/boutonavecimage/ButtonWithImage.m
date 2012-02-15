//
//  ButtonWithImage.m
//  dismoiou
//
//  Created by Romain on 28/10/10.
//  Copyright 2010 Badtech. All rights reserved.
//

#import "ButtonWithImage.h"
#import "UIHelper.h"


@implementation ButtonWithImage


- (id)initWithFrame:(CGRect)frame image:(NSString*)imgName legend:(NSString*)legend
{
    self = [super initWithFrame:frame];
    label = [[UIHelper newLabelColor:[UIColor darkGrayColor] fontSize:12 bold:YES] retain];
    label.text = legend;
    label.textAlignment = UITextAlignmentLeft;
    CGRect labelFrame = frame;
    labelFrame.origin.x +=35;
    labelFrame.size.width -=35;
    label.frame = labelFrame;
    label.userInteractionEnabled = NO;

    button = [[UIButton buttonWithType:UIButtonTypeCustom] retain]; 
    [button setFrame:frame];
    [button setBackgroundImage:[[UIImage imageNamed:imgName] 
                                    stretchableImageWithLeftCapWidth:35 topCapHeight:0.0] forState:UIControlStateNormal];
    [self addSubview:button];
    [self addSubview:label];
    return self;
}

- (void) dealloc
{
    [super dealloc];
    [label release];
    [button release];
}


- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    [button addTarget:target action:action forControlEvents:controlEvents];
}
@end
