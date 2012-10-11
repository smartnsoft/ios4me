//
//  SnSDropListView.h
//  ios4me
//
//  Created by Johan Attali on 12/06/12.
//  Copyright (c) 2012 Smart&Soft. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SnSDropListView;
@class SnSDropListViewCell;

@protocol SnSDropListDelegate <NSObject>

- (SnSDropListViewCell*)dropList:(SnSDropListView*)iDropList cellForRow:(NSInteger)iRow;

@optional

- (void)didTapDropListView:(SnSDropListView*)iDropList;

- (void)dropList:(SnSDropListView*)iDropList didSelectRow:(NSInteger)iRow;
- (CGFloat)dropList:(SnSDropListView*)iDropList heightForRow:(NSInteger)iRow;

- (void)dropList:(SnSDropListView*)iDropList willOpenScrollView:(UIScrollView*)iScrollView;
- (void)dropList:(SnSDropListView*)iDropList didOpenScrollView:(UIScrollView*)iScrollView;

- (void)dropList:(SnSDropListView*)iDropList willCloseScrollView:(UIScrollView*)iScrollView;
- (void)dropList:(SnSDropListView*)iDropList didCloseScrollView:(UIScrollView*)iScrollView;

@end

@protocol SnSDropListDataSource <NSObject>

@required

- (NSInteger)numberOfRowsInDropList:(SnSDropListView*)iDropListView;

@end

@interface SnSDropListView : UIView
{
	UILabel* mainLabel_;
	UIView* backgroundView_;
	UIScrollView* scrollview_;
	UIImageView* imgArrow_;
	UIImageView* imgBackground_;
	SnSDropListViewCell* selectedCell_;

	id<SnSDropListDelegate> delegate_;
	id<SnSDropListDataSource> dataSource_;
	
	CGFloat maxScrollHeight_;
	CGFloat expectedHeight_;
	CGFloat padding_;
    
	BOOL enabled_;
}

@property (nonatomic, assign) id<SnSDropListDelegate> delegate;
@property (nonatomic, assign) id<SnSDropListDataSource> dataSource;
@property (nonatomic, assign) CGFloat maxScrollHeight;
@property (nonatomic, assign) CGFloat padding;
@property (nonatomic, assign) BOOL enabled;
@property (nonatomic, readonly) UILabel* mainLabel;
@property (nonatomic, readonly) UIScrollView* scrollView;
@property (nonatomic, readonly) UIView* backgroundView;
@property (nonatomic, readonly) UIImageView* arrowImage;
@property (nonatomic, readonly) UIImageView* backgroundImage;

#pragma mark Internal Events

- (void)onTapMainView_:(id)sender;
- (void)onTapCellView_:(id)sender;

#pragma mark Actions

- (void)setup;
- (void)openScrollView;
- (void)closeScrollView;

#pragma mark Loading Data

- (void)reloadData;
- (NSInteger)selectedRow;
- (void)selectRow:(NSInteger)index;
@end
