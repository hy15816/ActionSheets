//
//  GridView.h
//  ActionSheet
//
//  Created by AEF-RD-1 on 15/10/22.
//  Copyright (c) 2015年 hyIm. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GridView;
@protocol GridViewDelegate <NSObject>
@required
/**
 *  GridView 的frame更新时，发出通知
 *
 *  @return YES是，NO否
 */
- (BOOL)gridViewWillUpdateFrame;

@optional
/**
 *  点击了哪个 button
 *
 *  @param gridView self
 *  @param buttonIndex button index
 */
- (void)gridView:(GridView *)gridView didClickButtonIndex:(NSInteger)buttonIndex;

/**
 *  gridView 的 frame 改变时，
 *
 *  @param gridView self
 *  @param size     change‘s size
 */
- (void)gridView:(GridView *)gridView didChangeSize:(CGSize)size;




@end

@interface GridView : UIView

/**
 *  button 左右之间的间距
 */
@property (assign,nonatomic) NSInteger buttonMarginLeft;

/**
 *  button 距离父view之间的top间距
 */
@property (assign,nonatomic) NSInteger buttonMarginTops;

/**
 *  label 的字体
 */
@property (strong,nonatomic) UIFont *labelFont;

/**
 *  是否显示底部分给线，默认不显示(NO)
 */
@property (assign,nonatomic) BOOL isShowLine;

/**
 *  创建一个view，view里包括button，label，并按照button上--label下的方式排版
 *
 *  @param frame        view的初始大小，高度可随意设置
 *  @param delegate     GridViewDelegate
 *  @param imgArray     button image
 *  @param titleArray   label text
 *  @param numberOfRows 每一行排列几个button&label， df 4个
 *
 *  @return GridView
 */
- (id)initWithFrame:(CGRect)frame delegate:(id<GridViewDelegate>)delegate buttonImage:(NSMutableArray *)imgArray title:(NSMutableArray *)titleArray numberOfRows:(NSInteger)numberOfRows;


@end
