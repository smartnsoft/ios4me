//
//  SnSStoreManager.h
//  SnSFramework
//
//  Created by Johan Attali on 8/10/11.
//  Copyright 2011 Smart&Soft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

#import "SnSSingleton.h"


@class SnSStoreManager;

@protocol SnSStoreManagerDelegate <NSObject>

@optional
- (void)storeManager:(SnSStoreManager*)storeManager didReceiveProductsData:(NSArray*)products;
- (void)storeManager:(SnSStoreManager*)storeManager didFinishTransaction:(SKPaymentTransaction*)transaction;
- (void)storeManager:(SnSStoreManager*)storeManager didFailedTransaction:(SKPaymentTransaction*)transaction;
- (void)storeManager:(SnSStoreManager*)storeManager didFailedRestoreTransactions:(SKPaymentQueue*)transaction;
- (void)storeManager:(SnSStoreManager*)storeManager didRestoreTransactions:(SKPaymentQueue*)transaction;
@end


@interface SnSStoreManager : SnSSingleton <SKProductsRequestDelegate,SKPaymentTransactionObserver>
{
	SKRequest* _request;
	NSArray* _products;
	id<SnSStoreManagerDelegate> _delegate;
}

@property (nonatomic, readonly) NSArray* products;
@property (nonatomic, retain) id<SnSStoreManagerDelegate> delegate;

- (void)buyProduct:(SKProduct*)iProduct;
- (void)buyProduct:(SKProduct*)iProduct quantity:(NSUInteger)iQuantity;
- (void)buyProductIdentifier:(NSString*)iStr;
- (void)buyProductIdentifier:(NSString*)iStr quantity:(NSUInteger)iQuantity;
- (void)requestProductData:(NSArray*)iProductsList;

#pragma mark Transactions

- (void)purchasingTransaction:(SKPaymentTransaction *)iTransaction;
- (void)completedTransaction:(SKPaymentTransaction *)iTransaction;
- (void)failedTransaction:(SKPaymentTransaction *)iTransaction;

@end

