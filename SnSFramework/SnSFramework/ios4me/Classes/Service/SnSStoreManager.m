//
//  SnSStoreManager.m
//  SnSFramework
//
//  Created by Johan Attali on 8/10/11.
//  Copyright 2011 Smart&Soft. All rights reserved.
//

#import "SnSStoreManager.h"
#import "SnSLog.h"

#define kStoreManagerActivation @"com.smartnsoft.??"


@implementation SnSStoreManager

#pragma mark - Init Methods

- (void)dealloc
{
    self.delegate = nil;
}

- (void)setup
{
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    _products = [[NSMutableDictionary alloc] init];
}

- (id)init
{
    if ((self = [super init]))
    {
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    }
    
    return self;
}

#pragma mark - Products

- (void)requestProductData:(NSArray *)iProductsList
{
    self.currentRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithArray:iProductsList]];
    self.currentRequest.delegate = self;
    [self.currentRequest start];
}

- (void)buyProduct:(NSString *)productIdentifier
{
    // By default only one quantity
    [self buyProduct:productIdentifier quantity:1];
}

- (void)buyProduct:(NSString *)productIdentifier quantity:(NSUInteger)iQuantity
{
    SKProduct *product = _products[productIdentifier];
    
    SKMutablePayment* aPayment = [SKMutablePayment paymentWithProduct:product];
    [aPayment setQuantity:iQuantity];
    
    [[SKPaymentQueue defaultQueue] addPayment:aPayment];
}

- (SKProduct *)retrieveProductWithProductIdentifier:(NSString *)identifier
{
    return _products[identifier];
}

- (void)cancelCurrentRequest
{
    if (self.currentRequest != nil && self.currentRequest )
    {
        [self.currentRequest cancel];
    }
}

#pragma mark - Transactions

- (void)purchasingTransaction:(SKPaymentTransaction *)iTransaction
{
    SnSLogD(@"%@::purchasingTransaction", self.class);
    
}

- (void)completedTransaction:(SKPaymentTransaction *)transaction
{
    if (self != nil)
    {
        SnSLogD(@"%@::completeTransaction", self.class);
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(storeManager:didFinishTransaction:)])
        {
            [self.delegate storeManager:self didFinishTransaction:transaction];
        }
    }
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction
{
    if (self != nil)
    {
        SnSLogD(@"%@::failedTransaction Reason: %@", self.class, [transaction.error localizedDescription]);
        
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(storeManager:didFailedTransaction:)])
        {
            [self.delegate storeManager:self didFailedTransaction:transaction];
        }
    }
}

- (void)restoredTransaction:(SKPaymentTransaction *)transaction
{
    SnSLogD(@"%@::restoredTransaction", self.class);
    
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)restoreTranscation
{
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

#pragma mark - SKProductsRequestDelegate

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    if (self != nil)
    {
        SnSLogD(@"%@::productsRequest:didReceiveResponse", self.class);
        
        for (__unused NSString *aInvalidProduct in [response invalidProductIdentifiers])
            SnSLogE(@"Unkown Product Identifier: %@", aInvalidProduct);
        
        for (SKProduct *product in [response products])
        {
            [_products setValue:product forKey:product.productIdentifier];
        }
        
        // Signal Delegate the products have been received
        if (self.delegate != nil && [_delegate respondsToSelector:@selector(storeManager:didReceiveProductsData:)])
        {
            [_delegate storeManager:self didReceiveProductsData:_products];
        }
    }
}

#pragma mark -
#pragma mark SKPaymentTransactionObserver methods

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchasing:
                [self purchasingTransaction:transaction];
                break;
            case SKPaymentTransactionStatePurchased:
                [self completedTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoredTransaction:transaction];
                break;
            default:
                break;
        }
    }
}

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
    SnSLogE(@"paymentQueue:restoreCompletedTransactionsFailedWithError:%@", [error localizedDescription]);
    if (self != nil && self.delegate != nil && [self.delegate respondsToSelector:@selector(storeManager:didFailedRestoreTransactions:)])
    {
        [self.delegate storeManager:self didFailedRestoreTransactions:queue];
    }
}

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    SnSLogD(@"%@::paymentQueueRestoreCompletedTransactionsFinished:", self.class);
    
    if (self != nil && self.delegate != nil && [self.delegate respondsToSelector:@selector(storeManager:didRestoreTransactions:)])
    {
        [self.delegate storeManager:self didRestoreTransactions:queue];
    }
}

@end
