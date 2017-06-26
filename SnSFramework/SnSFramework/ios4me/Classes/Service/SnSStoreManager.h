/*
 * (C) Copyright 2009-2011 Smart&Soft SAS (http://www.smartnsoft.com/) and contributors.
 *
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the GNU Lesser General Public License
 * (LGPL) version 3.0 which accompanies this distribution, and is available at
 * http://www.gnu.org/licenses/lgpl.html
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * Lesser General Public License for more details.
 *
 * Contributors:
 *     Smart&Soft - initial API and implementation
 */

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

#import "SnSSingleton.h"


@class SnSStoreManager;

@protocol SnSStoreManagerDelegate <NSObject>

@optional
- (void)storeManager:(SnSStoreManager*)storeManager didReceiveProductsData:(NSDictionary *)products;
- (void)storeManager:(SnSStoreManager*)storeManager didFinishTransaction:(SKPaymentTransaction *)transaction;
- (void)storeManager:(SnSStoreManager*)storeManager didFailedTransaction:(SKPaymentTransaction *)transaction;
- (void)storeManager:(SnSStoreManager*)storeManager didFailedRestoreTransactions:(SKPaymentQueue *)transaction;
- (void)storeManager:(SnSStoreManager*)storeManager didRestoreTransactions:(SKPaymentQueue *)transaction;
@end


@interface SnSStoreManager : SnSSingleton <SKProductsRequestDelegate,SKPaymentTransactionObserver>
{
}

@property (nonatomic, strong, readonly) NSMutableDictionary *products;
@property (nonatomic, assign) id<SnSStoreManagerDelegate> delegate;
@property (nonatomic, strong) SKRequest *currentRequest;

- (void)buyProduct:(NSString *)productIdentifier;
- (void)buyProduct:(NSString *)productIdentifier quantity:(NSUInteger)iQuantity;
- (void)requestProductData:(NSArray *)iProductsList;
- (void)cancelCurrentRequest;
- (SKProduct *)retrieveProductWithProductIdentifier:(NSString *)identifier;

#pragma mark Transactions

- (void)purchasingTransaction:(SKPaymentTransaction *)iTransaction;
- (void)completedTransaction:(SKPaymentTransaction *)iTransaction;
- (void)failedTransaction:(SKPaymentTransaction *)iTransaction;
- (void)restoreTranscations;

@end

