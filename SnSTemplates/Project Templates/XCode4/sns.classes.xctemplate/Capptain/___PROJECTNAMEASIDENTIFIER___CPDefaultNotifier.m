//
//  MemoryCPDefaultNotifier.m
//  Memory
//
//  Created by Matthias ROUBEROL on 15/07/13.
//  Copyright (c) 2013 Smart&Soft. All rights reserved.
//

#import "___PROJECTNAMEASIDENTIFIER___CPDefaultNotifier.h"

@implementation ___PROJECTNAMEASIDENTIFIER___CPDefaultNotifier


//-(NSString*)nibNameForCategory:(NSString*)category
//{
//    return @"HangmanCPNotificationView";
//}
//
//
///*!
// * This function is called when the notification view must be prepared, e.g. change texts,
// * icon etc... based on the specified content. This is the responsibility of this method to
// * associate actions to the buttons. At this point the notification is not yet attached to the
// * view hierarchy, so you can not have access to its superview.
// *
// * The provided custom view must contains the following subviews:
// *
// *  - `UIImageView` with tag 1 to display the notification icon
// *  - `UILabel` with tag 2 to display the notification's title
// *  - `UILabel` with tag 3 to display the notification's message
// *  - `UIImageView` with tag 4 to display the additional notification image
// *  - `UIButton` with tag 5 used when the notification is 'actioned'
// *  - `UIButton` with tag 6 used when the notification is 'exited'
// *
// * @param content Content to be notified.
// * @param view View used to display the notification.
// */
//-(void)prepareNotificationView:(UIView*)view forContent:(CPInteractiveContent*)content
//{
//    [super prepareNotificationView:view forContent:content];
//
//    UILabel * title = (UILabel *)[view viewWithTag:2];
//    if (title!=nil)
//    {
//        title.font = FONT_CHALKDUSTER(title.font.pointSize);
//        title.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
//        title.frame = CGRectMake(100, 50, 50, 100);
//    }
//
//    UILabel * message = (UILabel *)[view viewWithTag:3];
//    if (message!=nil)
//    {
//        message.font = FONT_CHALKDUSTER(message.font.pointSize);
//    }
//
//    UIButton * closeButton = (UIButton *)[view viewWithTag:6];
//    if (closeButton!=nil)
//    {
//        closeButton.hidden = YES;
//    }
//
//    UIButton * actionButton = (UIButton *)[view viewWithTag:5];
//    if (actionButton!=nil)
//    {
//        [actionButton setTitle:SnSLocalized(@"button.ok") forState:UIControlStateNormal];
//        [actionButton setTitleColor:COLOR_FFFFFF forState:UIControlStateNormal];
//        actionButton.titleLabel.font = FONT_CHALKDUSTER(actionButton.titleLabel.font.pointSize);
//        [actionButton setBackgroundImage:[SnSImageUtils imageNamed:@"common_button_petit"] forState:UIControlStateNormal];
//        [actionButton setBackgroundImage:[SnSImageUtils imageNamed:@"common_button_petit_on"] forState:UIControlStateHighlighted];
//        //[actionButton addTarget:self action:@selector(onNotificationActioned) forControlEvents:UIControlEventTouchUpInside];
//    }
//}

/*!
 * This method is called when a new notification view is requested for the given content.
 * By default this method load the view from the nib returned by <nibNameForCategory:>,
 * and prepare it by calling the method <prepareNotificationView:forContent:>.<br>
 * Subclasses can override this method to create a custom view for the given content.
 *
 * @param content Content to be notified. You can use the methods <[CPInteractiveContent notificationTitle]>,
 * <[CPInteractiveContent notificationMessage]>, <[CPInteractiveContent notificationIcon]>,
 * <[CPInteractiveContent notificationCloseable]>, <[CPInteractiveContent notificationImage]> to prepare your view.
 * @result View displaying the notification.
 */
-(UIView*)notificationViewForContent:(CPInteractiveContent*)content
{
    [[NSBundle mainBundle] loadNibNamed:kXib___PROJECTNAMEASIDENTIFIER___CPNotificationView owner:self options:nil];
    
    self.title.font = FONT_COMMON(self.title.font.pointSize);
    self.title.text = content.notificationTitle;
    self.message.font = FONT_COMMON(self.message.font.pointSize);
    self.message.text = content.notificationMessage;
    
    
    [self.actionButton addTarget:self action:@selector(onNotificationActioned) forControlEvents:UIControlEventTouchUpInside];
    [self.actionButton setTitle:SnSLocalized(@"button.ok") forState:UIControlStateNormal];
//    [self.actionButton setTitleColor:COLOR_FFFFFF forState:UIControlStateNormal];
//    self.actionButton.titleLabel.font = FONT_COMMON(self.actionButton.titleLabel.font.pointSize);
//    [self.actionButton setBackgroundImage:[SnSImageUtils imageNamed:@"common_button_petit"] forState:UIControlStateNormal];
//    [self.actionButton setBackgroundImage:[SnSImageUtils imageNamed:@"common_button_petit_on"] forState:UIControlStateHighlighted];
    
    return self.tempNotificationView;
    
    // Update height of message in scroll
    [SnSUILabelUtils setUILabel:self.message withMaxWidth:SnSViewW(self.messageScroll) withText:self.message.text usingVerticalAlign:0];
    // TODO self.message.width = SnSViewW(self.messageScroll);
    if (SnSViewH(self.message) > SnSViewH(self.messageScroll))
    {
        self.messageScroll.contentSize = CGSizeMake(SnSViewW(self.message), SnSViewH(self.message));
    }
    else
    {
        // TODO self.message.height = SnSViewH(self.messageScroll);
        self.messageScroll.contentSize = self.messageScroll.frame.size;
    }
}

/*!
 * Animate the overlay notification view when it appears.
 * Default implementation performs a vertical slide animation.
 * Subclasses can override this method to customize the animation.
 * @param view View to animate.
 */
-(void)animateOverlayNotificationView:(UIView*)view
{
    
}

- (void)dealloc {
    [_tempNotificationView release];
    [_actionButton release];
    [_title release];
    [_message release];
    [_messageScroll release];
    [super dealloc];
}

@end
