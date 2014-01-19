//
//  MemoryCPDefaultNotifier.h
//  Memory
//
//  Created by Matthias ROUBEROL on 15/07/13.
//  Copyright (c) 2013 Smart&Soft. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CPDefaultNotifier.h"

@interface ___PROJECTNAMEASIDENTIFIER___CPDefaultNotifier : CPDefaultNotifier

@property (retain, nonatomic) IBOutlet UIView *tempNotificationView;
@property (retain, nonatomic) IBOutlet UILabel *title;
@property (retain, nonatomic) IBOutlet UIScrollView *messageScroll;
@property (retain, nonatomic) IBOutlet UILabel *message;
@property (retain, nonatomic) IBOutlet UIButton *actionButton;

@end
