// UIImageView+SnSExtension.m
//
//  Inspired by UIImageView+AFNetwork.h
//
//  Created by Matthias Rouberol.
//  Copyright (c) 2013 Smart&Soft. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <objc/runtime.h>

#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
#import "UIImageView+SnSExtension.h"


#pragma mark -

static char kASIHTTPImageRequestOperationObjectKey;

@interface UIImageView (_SnSExtension)
@property (readwrite, nonatomic, strong, setter = sns_setImageRequestOperation:) ASIHTTPRequest *sns_imageRequestOperation;
@end

@implementation UIImageView (_SnSExtension)
@dynamic sns_imageRequestOperation;
@end

#pragma mark -

@implementation UIImageView (SnSExtension)

- (ASIHTTPRequest *)sns_imageRequestOperation {
    return (ASIHTTPRequest *)objc_getAssociatedObject(self, &kASIHTTPImageRequestOperationObjectKey);
}

- (void)sns_setImageRequestOperation:(ASIHTTPRequest *)imageRequestOperation {
    objc_setAssociatedObject(self, &kASIHTTPImageRequestOperationObjectKey, imageRequestOperation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (NSOperationQueue *)sns_sharedImageRequestOperationQueue {
    static NSOperationQueue *_sns_imageRequestOperationQueue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sns_imageRequestOperationQueue = [[NSOperationQueue alloc] init];
        [_sns_imageRequestOperationQueue setMaxConcurrentOperationCount:NSOperationQueueDefaultMaxConcurrentOperationCount];
    });

    return _sns_imageRequestOperationQueue;
}

#pragma mark -
//
- (void)setImageWithURL:(NSURL *)url {
    [self setImageWithURL:url placeholderImage:nil];
}

- (void)setImageWithURL:(NSURL *)url
       placeholderImage:(UIImage *)placeholderImage
{
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request addRequestHeader:@"Accept" value:@"image/*"];

    [self setImageWithURLHTTPRequest:request placeholderImage:placeholderImage success:nil failure:nil];
}

- (void)setImageWithURLHTTPRequest:(ASIHTTPRequest *)requestOperation
              placeholderImage:(UIImage *)placeholderImage
                       success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image))success
                       failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error))failure
{
    [self cancelImageRequestOperation];

    self.image = placeholderImage;
    
    [requestOperation setCompletionBlock:^{
        NSData* aResponseData  = [requestOperation responseData];
        UIImage* aImage = [UIImage imageWithData:aResponseData];
        
        if ([requestOperation isEqual:self.sns_imageRequestOperation]) {
            if (success) {
                success(nil, nil, aImage);
            } else if (aImage) {
                self.image = aImage;
            }
            
            if (self.sns_imageRequestOperation == requestOperation) {
                self.sns_imageRequestOperation = nil;
            }
        }
        
    }];
    
    [requestOperation setFailedBlock:^{
        
        if ([requestOperation isEqual:self.sns_imageRequestOperation]) {
            if (failure) {
                failure(nil, nil, [requestOperation error]);
            }
            
            if (self.sns_imageRequestOperation == requestOperation) {
                self.sns_imageRequestOperation = nil;
            }
        }
    }];
    
    self.sns_imageRequestOperation = requestOperation;
    
    [[[self class] sns_sharedImageRequestOperationQueue] addOperation:self.sns_imageRequestOperation];
}

- (void)cancelImageRequestOperation {
    // Specific ASIHTTPRequest
    [self.sns_imageRequestOperation clearDelegatesAndCancel];
    
    [self.sns_imageRequestOperation cancel];
    self.sns_imageRequestOperation = nil;
}

@end

#pragma mark -

#endif
