/* 
 * Copyright (C) 2009 Smart&Soft.
 * All rights reserved.
 *
 * The code hereby is the full property of Smart&Soft, SIREN 517 961 744.
 * http://www.smartnsoft.com - contact@smartnsoft.com
 * 
 * You are not allowed to use the source code or the resulting binary code, nor to modify the source code, without prior permission of the owner.
 *
 * This library is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 */

//
//  SnSImageDownloader.h
//  SnSFramework
//
//  Created by Édouard Mercier on 10/10/2009.
//

#import <Foundation/Foundation.h> 
#import <UIKit/UIImageView.h> 
#import <UIKit/UITableViewCell.h>

@interface SnSImageDownloader : NSObject
{
  @private NSMutableDictionary * work;
}

@property(nonatomic, retain) NSMutableDictionary * work;

@end

#pragma mark -
#pragma mark SnSDownloadImageOperation

@interface SnSDownloadImageDelegate : NSObject
{
}

- (void) onImageDownloaded:(UIImage *)image;

@end

@interface SnSDownloadImageOperation : NSOperation
{
  BOOL _useCache;
  NSString * _url;
  NSURL * imageUrl;
  NSURLRequest * urlRequest;
  SnSDownloadImageDelegate * callback;
}

//- (id) initAndEnqueue:(id)target andUrl:(NSString *) theUrl andTemporaryImage:(NSString *) imageResourceName;
//- (id) initWith:(id)target andUrl:(NSString *) theUrl andTemporaryImage:(NSString *) imageResourceName;// andDelegate:(DownloadImageDelegate *) theCallback;

@end

@interface SnSImageViewDownloadImageOperation : SnSDownloadImageOperation
{
  UIImageView * imageView;
  UIActivityIndicatorView * activity;
}

- (id) initWith:(BOOL)useCache andTarget:(UIImageView *)target andUrl:(NSString *)url andTemporaryImage:(NSString *)imageResourceName;
/*
 Should be invoked from the GUI thread!
*/
- (id) initAndEnqueueWith:(BOOL)useCache andTarget:(UIImageView *)target andUrl:(NSString *)url andTemporaryImage:(NSString *)imageResourceName;

@end

@interface SnSTableViewCellDownloadImageOperation : SnSDownloadImageOperation
{
  UITableViewCell * tableViewCell;
}

- (id) initWith:(BOOL)useCache andTarget:(UITableViewCell *)target andUrl:(NSString *)theUrl andTemporaryImage:(NSString *)imageResourceName;
/*
 Should be invoked from the GUI thread!
*/
- (id) initAndEnqueueWith:(BOOL)useCache andTarget:(UITableViewCell *)target andUrl:(NSString *)url andTemporaryImage:(NSString *)imageResourceName;

@end
