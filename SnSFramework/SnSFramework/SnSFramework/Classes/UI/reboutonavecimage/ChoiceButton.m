//
//  ChoiceButton.m
//  Choice
//
//  Created by Romain on 14/09/10.
//  Copyright 2010 Badtech. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ChoiceButton.h"

@implementation NoAnimationShapeLayer
//Remove antimations when refreshing the layer
- (id<CAAction>)actionForKey:(NSString *)event
{
    if ([event isEqualToString:@"contents"])
        return nil;
    if ([event isEqualToString:@"onOrderIn"])
        return nil;
    if ([event isEqualToString:@"onOrderOut"])
        return nil;
    if ([event isEqualToString:@"sublayers"])
        return nil;
    if ([event isEqualToString:@"bounds"])
        return nil;
    
    return [super actionForKey:event];
}
@end

@implementation NoAnimationShapeCAGradientLayer
//Remove antimations when refreshing the layer
- (id<CAAction>)actionForKey:(NSString *)event
{
    if ([event isEqualToString:@"contents"])
        return nil;
    return [super actionForKey:event];
}
@end

@interface ChoiceButton (private)
- (void) blinkLayer:(CALayer*)layer;
- (void) endOpacity:(NSTimer*)timer;
- (BOOL) layer:(CALayer*)layer1 isIn:(CALayer*)layer2;
@end


@implementation LayerButton

- (id)initWithText:(NSString*)text
{
    self = [super init];
    [self setCornerRadius:8.0f];
    [self setBorderWidth:1.0f]; 
    [self setMasksToBounds:YES];
    UIFont *font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:20];
    editLayer = [[TextLayer textLayerInSuperlayer: self
                                         withText: text          
                                             font: font
                                            color: [UIColor blackColor]
                                        alignment: kCALayerNotSizable] retain];
    CGSize size = [text sizeWithFont:font];
    editLayer.frame = CGRectMake(0, 0, size.width, size.height);
    editLayer.hidden = NO;
    return self;
}

- (void) setFrame:(CGRect)rect
{
    CGRect editLayerFrame = editLayer.frame;
    editLayer.position = CGPointMake((int)(10 + (rect.size.width-20)/2 - editLayerFrame.size.width/2), 
                                     (int)(rect.size.height/2) - 10);        
    [super setFrame:rect];
}

-(void) setHidden:(BOOL)h
{
    editLayer.hidden = h;
    [super setHidden:h];
}

@end


@implementation ChoiceButton

@synthesize buttonState, buttonId, buttonImage;
@synthesize buttonDelegate;

int c(int i)
{
    return (int)(i/255);
}

- (id)initWithFrame:(CGRect)aRect
{
    self = [super initWithFrame:aRect];
    self.backgroundColor = [UIColor clearColor];
    
    // Initialize the gradient layer
    gradientLayer = [[CAGradientLayer alloc] init];
    imageLayer = [[NoAnimationShapeLayer alloc] init];
    // Set its bounds to be the same of its parent
    [gradientLayer setBounds:[self bounds]];
    [imageLayer setBounds:[self bounds]];
    // Center the layer inside the parent layer
    [gradientLayer setPosition: CGPointMake([self bounds].size.width/2, [self bounds].size.height/2)];
    [imageLayer setPosition: CGPointMake([self bounds].size.width/2, [self bounds].size.height/2)];
    
    NSMutableDictionary *newActions = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSNull null], @"onOrderIn",
                                       [NSNull null], @"onOrderOut",
                                       [NSNull null], @"sublayers",
                                       [NSNull null], @"contents",
                                       [NSNull null], @"bounds",
                                       nil];
    imageLayer.actions = newActions;
    [newActions release];
    
    // Insert the layer at position zero to make sure the 
    // text of the button is not obscured
    [[self layer] insertSublayer:gradientLayer atIndex:1];
    [[self layer] insertSublayer:imageLayer atIndex:0];
        
    closeButton = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    closeButton.image = [UIImage imageNamed:@"closebutton.png"];
    
    // Turn on masking
    [[self layer] setMasksToBounds:YES];
    // Display a border around the button 
    // with a 1.0 pixel width
    [[self layer] setBorderWidth:1.0f];    

    editButtonLayer = [[LayerButton alloc] initWithText:@"Edit"];
    [[self layer] insertSublayer:editButtonLayer atIndex:2];
    
    selectButtonLayer = [[LayerButton alloc] initWithText:@"select"];
    [[self layer] insertSublayer:selectButtonLayer atIndex:2];    
    
    return self;
}

- (UIImage *) resizeImage:(UIImage*)image dimension:(int)dim;
{
    float imageWidth = image.size.width;
    float imageHeight = image.size.height; 
 
    CGRect imgRect;
    if(imageWidth > imageHeight)
    {
        int h = dim;
        int w = dim * imageWidth / imageHeight;
        imgRect = CGRectMake(0, 0, w, h);
    }
    else 
    {
        int h = dim * imageHeight / imageWidth;
        int w = dim;
        imgRect = CGRectMake(0, 0, w, h);
    }

    UIGraphicsBeginImageContext(imgRect.size);
    [image drawInRect:imgRect];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
    
    /*
    
    float actualHeight = image.size.height;
    float actualWidth = image.size.width;
    float imgRatio = actualWidth/actualHeight;
    float maxRatio = size.width/size.height;
    
    if(imgRatio!=maxRatio){
        if(imgRatio < maxRatio){
            imgRatio = size.height / actualHeight;
            actualWidth = imgRatio * actualWidth;
            actualHeight = size.height;
        }
        else{
            imgRatio = size.width / actualWidth;
            actualHeight = imgRatio * actualHeight;
            actualWidth = size.width;
        }
    }
    CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
    UIGraphicsBeginImageContext(rect.size);
    [image drawInRect:rect];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
     */
}

- (UIImage *) cropImage:(UIImage*)image size:(CGRect)rect
{
    CGSize size = image.size;
    rect.origin.x = (int)(fabs(size.width - rect.size.width)/2);
    rect.origin.y = (int)(fabs(size.height - rect.size.height)/2);
    CGImageRef tmp = CGImageCreateWithImageInRect(image.CGImage, rect);
    return [UIImage imageWithCGImage:tmp];
}


- (void)setButtonImage:(UIImage *)image
{
    [buttonImage release];
    buttonImage = [image retain];
    
    [buttonImageBig release];
    buttonImageBig = nil;
    
    [buttonImageSquare release];
    UIImage *img = [self resizeImage:image dimension:140];
    buttonImageSquare = [[self cropImage:img size:CGRectMake(0, 50, 140, 140)]retain];
    
    imageLayer.contents = (id)buttonImageSquare.CGImage;
    [imageLayer setNeedsLayout];
}

- (void)drawRect:(CGRect)rect;
{
    [imageLayer setBounds:rect];
    [imageLayer setPosition: CGPointMake(rect.size.width/2, rect.size.height/2)];

    UIColor *_lowColor = nil;
    UIColor *_highColor = nil;

    //manage visibility:
    if(buttonState == ChoiceButtonStateBig)
    {
        if(!buttonImageBig)
        {
            if(rect.size.width > rect.size.height)
            {
                UIImage *img = [self resizeImage:buttonImage dimension:rect.size.width];
                int delta = rect.size.width - rect.size.height;
                buttonImageBig = [[self cropImage:img size:CGRectMake(0, delta, rect.size.width, rect.size.height)] retain];            
            }
            else 
            {
                UIImage *img = [self resizeImage:buttonImage dimension:rect.size.height];
                int delta = rect.size.height - rect.size.width;
                buttonImageBig = [[self cropImage:img size:CGRectMake(delta, 0, rect.size.width, rect.size.height)] retain];            
            }            
        }
        imageLayer.contents = (id)buttonImageBig.CGImage;
        
        gradientLayer.hidden = YES;
        editButtonLayer.hidden = YES;
        selectButtonLayer.hidden = YES; 
        
        closeButton.hidden = NO;
        closeButton.frame =  CGRectMake(rect.size.width - 35, 5, 30, 30);
        // Set the layer's corner radius
        [[self layer] setCornerRadius:0];
    }
    else if(buttonState == ChoiceButtonStateExpanded)
    {
        imageLayer.contents = (id)buttonImageSquare.CGImage;
        // Set the layer's corner radius
        [[self layer] setCornerRadius:8.0f];
        [gradientLayer setCornerRadius:8.0f];

        _lowColor = [UIColor colorWithWhite:0.5 alpha:0.8];
        _highColor = [UIColor colorWithWhite:1 alpha:0.6];
        
        selectButtonLayer.frame = CGRectMake(10, 10, rect.size.width - 20, 60);
        editButtonLayer.frame = CGRectMake(10, rect.size.height - 50, rect.size.width - 20, 30);
        [editButtonLayer setBackgroundColor:[UIColor grayColor].CGColor];
        [selectButtonLayer setBackgroundColor:[UIColor grayColor].CGColor];

        //closeButtonLayer.hidden = YES;
        closeButton.hidden = YES;
        gradientLayer.hidden = NO;
        editButtonLayer.hidden = NO;
        selectButtonLayer.hidden = NO;
    }
    else
    {
        imageLayer.contents = (id)buttonImageSquare.CGImage;
        // Set the layer's corner radius
        [[self layer] setCornerRadius:8.0f];
        [gradientLayer setCornerRadius:8.0f];

        _lowColor = [UIColor colorWithWhite:0 alpha:0.3];
        _highColor = [UIColor colorWithWhite:1 alpha:0.1];
        
        //closeButtonLayer.hidden = YES;
        closeButton.hidden = YES;
        gradientLayer.hidden = NO;
        editButtonLayer.hidden = YES;
        selectButtonLayer.hidden = YES;
    }
    [gradientLayer setBounds:rect];
    
    // Center the layer inside the parent layer
    [gradientLayer setPosition: CGPointMake(rect.size.width/2, rect.size.height/2)];
    
    if (_highColor && _lowColor)
    {
        // Set the colors for the gradient to the 
        // two colors specified for high and low
        [gradientLayer setColors:
         [NSArray arrayWithObjects:
          (id)[_highColor CGColor], 
          (id)[_lowColor CGColor], nil]];
    }
    
    [super drawRect:rect];
//    [self.layer addSublayer:[closeButton layer]];
    [[self layer] insertSublayer:[closeButton layer] atIndex:3];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{ 
    if ([touches count] == 1) 
    { 
        for (UITouch *touch in touches) 
        {
            CALayer *touchedLayer = [[touch view] layer];
            CGPoint point = [touch locationInView:self]; 
            point = [self.layer convertPoint:point toLayer:self.layer.superlayer];            
            CALayer *subTouchedLayer = [touchedLayer hitTest:point];
            
            if([self layer:subTouchedLayer isIn:editButtonLayer])            
            {
                [self blinkLayer:editButtonLayer];
            }
            /*
            else if([self layer:subTouchedLayer isIn:closeButtonLayer])            
            {
                [self blinkLayer:closeButtonLayer];
            }
             */
            else if([self layer:subTouchedLayer isIn:[closeButton layer]])            
            {
                [self blinkLayer:[closeButton layer]];
            }            
            else if([self layer:subTouchedLayer isIn:selectButtonLayer])            
            {
                [self blinkLayer:selectButtonLayer];
            }
            
            else 
            {
                [self.nextResponder touchesBegan:touches withEvent:event];
            }
        } 
    } 
}

- (BOOL) layer:(CALayer*)layer1 isIn:(CALayer*)layer2
{
    if([layer1 isEqual:layer2])
        return YES;
    
    for(CALayer *subLayer in layer2.sublayers)
    {
        if([layer1 isEqual:subLayer])
            return YES;
    }
    
    return NO;
}

- (void) blinkLayer:(CALayer*)layer
{
    // add an highlight effect with opacity
    CABasicAnimation *theAnimation=[CABasicAnimation animationWithKeyPath:@"opacity"];
    theAnimation.duration=0.1;
    theAnimation.repeatCount=0;
    theAnimation.autoreverses=YES;
    theAnimation.fromValue=[NSNumber numberWithFloat:1.0];
    theAnimation.toValue=[NSNumber numberWithFloat:0.2];
    [layer addAnimation:theAnimation forKey:@"animateOpacity"];
    
    // setting a timer to remove the layer
    [NSTimer scheduledTimerWithTimeInterval:(0.2) target:self selector:@selector(endOpacity:) userInfo:layer repeats:NO];
    
}

- (void) endOpacity:(NSTimer*)timer 
{
    CALayer *layer = ((CALayer*)timer.userInfo);
	[layer removeAllAnimations];
    if(!buttonDelegate)
        return;
    
    if([layer isEqual:editButtonLayer])
        [buttonDelegate performSelector:@selector(editButton:) withObject:self];
    else if([layer isEqual:selectButtonLayer])
        [buttonDelegate performSelector:@selector(selectButton:) withObject:self];
    else if([layer isEqual:[closeButton layer]])
        [buttonDelegate performSelector:@selector(closeButton:) withObject:self];
    /*
    else if([layer isEqual:closeButtonLayer])
        [buttonDelegate performSelector:@selector(closeButton:) withObject:self];
     */

}

-(void)doWiggle:(CALayer *)touchedLayer  
{
    
	// grabbing the layer of the tocuhed view.
	//CALayer *touchedLayer = [touchView layer];
    
	// here is an example wiggle
	CABasicAnimation *wiggle = [CABasicAnimation animationWithKeyPath:@"transform"];
	wiggle.duration = 0.1;
	wiggle.repeatCount = 1e100f;
	wiggle.autoreverses = YES;
	wiggle.toValue = [NSValue valueWithCATransform3D:CATransform3DRotate(touchedLayer.transform,0.1, 0.0 ,1.0 ,2.0)];
    
	// doing the wiggle
	[touchedLayer addAnimation:wiggle forKey:@"wiggle"];
    
	// setting a timer to remove the layer
	//NSTimer *wiggleTimer = [NSTimer scheduledTimerWithTimeInterval:(2) target:self selector:@selector(endWiggle:) userInfo:touchedLayer repeats:NO];
    
}

/*
-(void)endWiggle:(NSTimer*)timer {
	// stopping the wiggle now
	[((CALayer*)timer.userInfo) removeAllAnimations];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event 
{    
	UITouch *touch = [[event allTouches] anyObject];

    CALayer *touchedLayer = [[touch view] layer];
    CGPoint point = [touch locationInView:[touch view]]; 
    
    CALayer *subTouchedLayer = [touchedLayer hitTest:point];

    [self doWiggle:editLayer];
    return;
    
    [self doWiggle:[[touch view] layer]];
}
 */
@end
