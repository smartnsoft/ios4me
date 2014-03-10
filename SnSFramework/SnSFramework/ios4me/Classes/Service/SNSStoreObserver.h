//
//  RMSStoreObserver.h
//  RichMorningShow-iPad
//
//  Created by Johan Attali on 8/28/12.
//  Copyright (c) 2012 Smart&Soft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import "SnSSingleton.h"

@protocol SnSPurchaseDelegate <NSObject>

@required

- (NSArray*)products;

@optional

- (void)didCompletePurchaseProduct:(SKProduct*)product;
- (void)didFailPurchaseProduct:(SKProduct*)product error:(NSError*)error;

@end

@interface SnSStoreObserver : SnSSingleton <SKPaymentTransactionObserver>
{
    id <SnSPurchaseDelegate> delegate_;
}

@property (nonatomic, assign) id <SnSPurchaseDelegate> delegate;

- (SKProduct*)productFromTransaction:(SKPaymentTransaction*)transaction;

#pragma mark Process Response

- (void)processErrorOnTransaction:(SKPaymentTransaction*)transaction;
- (void)processPurchasedOnTransaction:(SKPaymentTransaction*)transaction;
- (void)processRestoredOnTransaction:(SKPaymentTransaction*)transaction;

@end
