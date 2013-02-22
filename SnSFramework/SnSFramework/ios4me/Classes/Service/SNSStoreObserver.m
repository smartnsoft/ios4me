//
//  SNSStoreObserver.m
//  RichMorningShow-iPad
//
//  Created by Johan Attali on 8/28/12.
//  Copyright (c) 2012 Smart&Soft. All rights reserved.
//

#import "SNSStoreObserver.h"

@implementation SnSStoreObserver
@synthesize delegate = delegate_;

+ (SnSStoreObserver*)instance
{
    return (SnSStoreObserver*)[super instance];
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchasing:
                SnSLogI(@"[PURCHASE] - Purchasing %@", transaction.payment.productIdentifier);
                break;
            case SKPaymentTransactionStateRestored:
                [self processRestoredOnTransaction:transaction];
                break;
            case SKPaymentTransactionStatePurchased:
                [self processPurchasedOnTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
#               if TARGET_IPHONE_SIMULATOR
                    [self processPurchasedOnTransaction:transaction];
#               else
                    [self processErrorOnTransaction:transaction];
#               endif
            default:
                SnSLogE(@"Error while purchasing %@ : %@",
                        transaction.payment.productIdentifier,
                        transaction.error);
                break;
        }
    }
}

- (SKProduct *)productFromTransaction:(SKPaymentTransaction *)transaction
{
    if (![delegate_ respondsToSelector:@selector(products)])
        return nil;
    
    for (SKProduct* product in [delegate_ products])
    {
        if ([product.productIdentifier isEqualToString:transaction.payment.productIdentifier])
            return product;
    }
    
    return nil;
}

#pragma mark Process

- (void)processErrorOnTransaction:(SKPaymentTransaction *)transaction
{
    SnSLogE(@"[PURCHASE] - error on %@ : %@",
            transaction.payment.productIdentifier,
            transaction.error);
    
    if ([delegate_ respondsToSelector:@selector(didFailPurchaseProduct:error:)])
        [delegate_ didFailPurchaseProduct:[self productFromTransaction:transaction] error:transaction.error];
    
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)processPurchasedOnTransaction:(SKPaymentTransaction *)transaction
{
    SnSLogI(@"[PURCHASE] - success on %@",
            transaction.payment.productIdentifier);
    
    if ([delegate_ respondsToSelector:@selector(didCompletePurchaseProduct:)])
        [delegate_ didCompletePurchaseProduct:[self productFromTransaction:transaction]];
    
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    
}

- (void)processRestoredOnTransaction:(SKPaymentTransaction *)transaction
{
    SnSLogI(@"[PURCHASE] - restore on %@",
            transaction.payment.productIdentifier);
    
    if ([delegate_ respondsToSelector:@selector(didCompletePurchaseProduct:)])
        [delegate_ didCompletePurchaseProduct:[self productFromTransaction:transaction]];
    
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

@end
