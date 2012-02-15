//
//  ChoiceButton.h
//  Choice
//
//  Created by Romain on 14/09/10.
//  Copyright 2010 Badtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "TextLayer.h"

typedef enum 
{
    ChoiceButtonStateReduced = 0,
    ChoiceButtonStateExpanded = 1,   
    ChoiceButtonStateBig = 2   
} ChoiceButtonState;

@interface NoAnimationShapeLayer : CALayer
@end
@interface NoAnimationShapeCAGradientLayer : CAGradientLayer
@end

@interface LayerButton : NoAnimationShapeLayer
{
    TextLayer *editLayer;
}

- (id)initWithText:(NSString*)text;
@end


@protocol ChoiceButtonDelegate;

@interface ChoiceButton : UIButton 
{
    CAGradientLayer *gradientLayer;
    NoAnimationShapeLayer *imageLayer;
    UIImageView *closeButton;
    
    LayerButton *editButtonLayer;
    LayerButton *selectButtonLayer;
    
    ChoiceButtonState buttonState;
    int buttonId;
    id<ChoiceButtonDelegate> buttonDelegate;
    UIImage *buttonImage;
    
    UIImage *buttonImageSquare;
    UIImage *buttonImageBig;
}

@property (nonatomic, assign) ChoiceButtonState buttonState;
@property (nonatomic, assign) int buttonId;
@property (nonatomic, assign) id<ChoiceButtonDelegate> buttonDelegate;
@property (nonatomic, retain) UIImage *buttonImage;
@end

@protocol ChoiceButtonDelegate <NSObject>
- (void) closeButton:(ChoiceButton*)button;
- (void) editButton:(ChoiceButton*)button;
- (void) selectButton:(ChoiceButton*)button;
@end
