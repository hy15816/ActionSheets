//
//  LoopViews.h
//  ActionSheet
//
//  Created by AEF-RD-1 on 15/10/23.
//  Copyright (c) 2015年 hyIm. All rights reserved.
//  图片滚动

#import <UIKit/UIKit.h>
@class LoopView;
@protocol LoopViewDelegate <NSObject>
@optional
/**
 *  点击了哪张图片,
 *
 *  @param loopView current LoopView
 *  @param index    item index
 */
- (void)loopView:(LoopView *)loopView didSelectItem:(NSInteger)index;

@end

@interface LoopView : UIView
/**
 *  滚动时间间隔，df 1.5s
 */
@property (assign,nonatomic) CGFloat loopTimeInterval;

/**
 *  创建一个view，包括了images (must)，title(可以没有)，pagesCtrol(有title时居右，无title时居中显示),可以自动滚动,可设定滚动的间隔时间，
 *
 *  @param frame  view 的 frame
 *  @param delegate LoopViewDelegate
 *  @param images images array
 *  @param titles title array
 *
 *  @return LoopView
 */
+ (instancetype)loopViewWithFrame:(CGRect)frame delegate:(id<LoopViewDelegate>)delegate imagesArray:(NSMutableArray *)images titleArray:(NSMutableArray *)titles;
@end
