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

@synthesize products = _products;
@synthesize delegate = _delegate;

#pragma mark - Init Methods

- (void)dealloc
{
	[_products release];
	
	[super dealloc];
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

- (void)requestProductData:(NSArray*)iProductsList
{
	@synchronized(_request)
	{
		_request= [[SKProductsRequest alloc] initWithProductIdentifiers: [NSSet setWithArray:iProductsList]];
		_request.delegate = self;
		[_request start];
	}
}

- (void)buyProduct:(SKProduct*)iProduct
{
	// By default only one quantity
	[self buyProduct:iProduct quantity:1];
}

- (void)buyProduct:(SKProduct*)iProduct quantity:(NSUInteger)iQuantity
{
	SKMutablePayment* aPayment = [SKMutablePayment paymentWithProduct:iProduct];
	[aPayment setQuantity:iQuantity];
	
	[[SKPaymentQueue defaultQueue] addPayment:aPayment];
}

#pragma mark - Transactions

- (void)purchasingTransaction:(SKPaymentTransaction *)iTransaction
{	
	SnSLogD(@"%@::purchasingTransaction", self.class);
	
}
- (void)completedTransaction:(SKPaymentTransaction *)transaction 
{
	SnSLogD(@"%@::completeTransaction", self.class);
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
	if ([self.delegate respondsToSelector:@selector(storeManager:didFinishTransaction:)])
		[self.delegate storeManager:self didFinishTransaction:transaction];
}


- (void)failedTransaction:(SKPaymentTransaction *)transaction 
{
	SnSLogD(@"%@::failedTransaction Reason: %@", self.class, [transaction.error localizedDescription]);

    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
	if ([self.delegate respondsToSelector:@selector(storeManager:didFailedTransaction:)])
		[self.delegate storeManager:self didFailedTransaction:transaction];
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
	SnSLogD(@"%@::productsRequest:didReceiveResponse", self.class);
	
	for (NSString* aInvalidProduct in [response invalidProductIdentifiers])
	{
		SnSLogE(@"Unkown Product Identifier: %@", aInvalidProduct);
	}
	
	_products = [[NSArray alloc] initWithArray:[response products]];
	
	// Signal Delegate the products have been received
	if ([_delegate respondsToSelector:@selector(storeManager:didReceiveProductsData:)])
		[_delegate storeManager:self didReceiveProductsData:_products];
	
	
	// Now release the request object
	@synchronized(_request)
		{ [_request release]; }
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
	if ([self.delegate respondsToSelector:@selector(storeManager:didFailedRestoreTransactions:)])
		[self.delegate storeManager:self didFailedRestoreTransactions:queue];
}

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue 
{
	SnSLogD(@"%@::paymentQueueRestoreCompletedTransactionsFinished:", self.class);

	if ([self.delegate respondsToSelector:@selector(storeManager:didRestoreTransactions:)])
		[self.delegate storeManager:self didRestoreTransactions:queue];
}


@end
