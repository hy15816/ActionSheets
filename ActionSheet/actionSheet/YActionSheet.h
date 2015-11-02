//
//  YActionSheet.h
//  ActionSheet
//
//  Created by AEF-RD-1 on 15/10/20.
//  Copyright (c) 2015年 hyIm. All rights reserved.
//


#import <UIKit/UIKit.h>

@protocol HYActionSheetDelegate  <NSObject>

/**
 *  点击了哪个button
 *
 *  @param buttonIndex button index
 */
- (void)didClickOnButtonIndex:(NSInteger)buttonIndex;

@optional
/**
 *  点击了cancel button
 */
- (void)didClickOnCancelButton;

/**
 *  点击了destructive button
 */
- (void)didClickOnDestructiveButton;

@end

@interface YActionSheet : UIView
/**
 *  创建一个actionSheet,包括标题(yes/no),destructive button(yes/no),otherBtn由一个数组传递,
 *
 *  @param title                  title
 *  @param delegate               HYActionSheetDelegate
 *  @param cancelButtonTitle      cancel button
 *  @param destructiveButtonTitle destructive button
 *  @param otherButtonTitlesArray other btn
 *
 *  @return YActionSheet
 */
- (id)initWithTitle:(NSString *)title delegate:(id<HYActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSArray *)otherButtonTitlesArray;

/**
 *  创建一个action sheet,显示一张图片，和一个button
 *
 *  @param imgName     image's name
 *  @param delegate     HYActionSheetDelegate
 *  @param cancelTitle cancel button
 *
 *  @return self
 */
- (id)initWithImageName:(NSString *)imgName delegate:(id<HYActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelTitle;

/**
 *  显示actionSheet
 *
 *  @param view 显示在view上
 */
- (void)showInView:(UIView *)view;

@end

