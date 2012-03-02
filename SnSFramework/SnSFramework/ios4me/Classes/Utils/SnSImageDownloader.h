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
