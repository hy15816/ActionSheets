//
//  YActionSheet.m
//  ActionSheet
//
//  Created by AEF-RD-1 on 15/10/20.
//  Copyright (c) 2015年 hyIm. All rights reserved.
//

#import "YActionSheet.h"

#define CANCEL_BUTTON_COLOR                     [UIColor colorWithRed:53/255.00f green:53/255.00f blue:53/255.00f alpha:1]
#define WINDOW_COLOR                            [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1]//[UIColor clearColor]//
#define ACTIONSHEET_BACKGROUNDCOLOR             [UIColor colorWithRed:106/255.00f green:106/255.00f blue:106/255.00f alpha:0.8]
#define DESTRUCTIVE_BUTTON_COLOR                [UIColor colorWithRed:185/255.00f green:45/255.00f blue:39/255.00f alpha:1]
#define OTHER_BUTTON_COLOR                      [UIColor whiteColor]

#define kBackgroungMarginLeft   0  //backgroung 距离屏幕左边距
#define kCornerRadius   5
#define kButtonHeight   40  //button 高度
#define kButtonMargin   20  //控件距离屏幕左右间距
#define kButtonWidth    self.backgroundView.frame.size.width-kButtonMargin*2       //button 控件宽度
#define kButtonTitleFont    [UIFont fontWithName:@"HelveticaNeue-Bold" size:18] //button 文字字体及大小
#define kButtonBorderWidth  0.5f                                                //button 边框线的大小
#define kButtonBorderColor  [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.8].CGColor //button 边框线的颜色
#define BUTTON_INTERVAL_HEIGHT                  20  //控件垂直间距
#define BUTTON_HEIGHT                           40  //button 高度
#define BUTTON_INTERVAL_WIDTH                   20  //控件距离屏幕左右间距
#define BUTTON_WIDTH                            self.backgroundView.frame.size.width-BUTTON_INTERVAL_WIDTH*2       //button 控件宽度
#define BUTTONTITLE_FONT                        [UIFont fontWithName:@"HelveticaNeue-Bold" size:18] //button 文字字体及大小
#define BUTTON_BORDER_WIDTH                     0.5f                                                //button 边框线的大小
#define BUTTON_BORDER_COLOR                     [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.8].CGColor //button 边框线的颜色
#define TITLE_INTERVAL_HEIGHT                   10          //title 距离顶端的高度
#define TITLE_HEIGHT                            35          //title 控件的高度
#define TITLE_INTERVAL_WIDTH                    30          //title 距离屏幕左右间距
#define TITLE_WIDTH                             self.backgroundView.frame.size.width-TITLE_INTERVAL_WIDTH*2        //title 控件宽度
#define TITLE_FONT                              [UIFont fontWithName:@"Helvetica-Bold" size:14]     //title 文字字体及大小
#define SHADOW_OFFSET                           CGSizeMake(0, 0.8f)                                 //title 阴影效果
#define TITLE_NUMBER_LINES                      2
#define ANIMATE_DURATION                        0.25f       //动画持续时间

#import "YActionSheet.h"

@interface YActionSheet ()

@property (strong,nonatomic) UIView *backgroundView;
@property (assign,nonatomic) NSInteger indexNumber;
@property (assign,nonatomic) BOOL isShowTitle;
@property (assign,nonatomic) BOOL isShowDestructiveButton;
@property (assign,nonatomic) BOOL isShowOtherButton;
@property (assign,nonatomic) BOOL isShowCancelButton;
@property (assign,nonatomic) BOOL isShowImageView;
@property (assign,nonatomic) CGFloat ActionSheetHeight;
@property (assign,nonatomic) id<HYActionSheetDelegate>delegate;

@end

@implementation YActionSheet

- (id)initWithTitle:(NSString *)title delegate:(id<HYActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSArray *)otherButtonTitlesArray;
{
    self = [super init];
    if (self) {
        
        //初始化背景视图，添加手势
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        self.backgroundColor = WINDOW_COLOR;
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCancel)];
        [self addGestureRecognizer:tapGesture];
        
        if (delegate) {
            self.delegate = delegate;
        }
        
        
        [self creatButtonsWithTitle:title cancelButtonTitle:cancelButtonTitle destructiveButtonTitle:destructiveButtonTitle otherButtonTitles:otherButtonTitlesArray];
        
    }
    return self;
}

- (void)creatButtonsWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSArray *)otherButtonTitlesArray{
    //初始化
    self.isShowTitle = NO;
    self.isShowDestructiveButton = NO;
    self.isShowOtherButton = NO;
    self.isShowCancelButton = NO;
    
    //初始化LXACtionView的高度为0
    self.ActionSheetHeight = 0;
    
    //初始化IndexNumber为0;
    self.indexNumber = 0;
    
    //生成LXActionSheetView
    self.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(kBackgroungMarginLeft, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width-kBackgroungMarginLeft*2, 0)];
    self.backgroundView.backgroundColor = ACTIONSHEET_BACKGROUNDCOLOR;
//    self.backgroundView.layer.cornerRadius = kCornerRadius;
    
    //给LXActionSheetView添加响应事件
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedBackGroundView)];
    [self.backgroundView addGestureRecognizer:tapGesture];
    
    [self addSubview:self.backgroundView];
    
    if (title) {
        self.isShowTitle = YES;
        UILabel *titleLabel = [self creatTitleLabelWith:title];
        self.ActionSheetHeight = self.ActionSheetHeight + 2*TITLE_INTERVAL_HEIGHT+TITLE_HEIGHT;
        [self.backgroundView addSubview:titleLabel];
    }
    
    if (destructiveButtonTitle) {
        self.isShowDestructiveButton = YES;
        
        UIButton *destructiveButton = [self creatDestructiveButtonWith:destructiveButtonTitle];
        destructiveButton.tag = self.indexNumber;
        [destructiveButton addTarget:self action:@selector(clickOnButtonWith:) forControlEvents:UIControlEventTouchUpInside];
        
        if (self.isShowTitle == YES) {
            //当有title时
            [destructiveButton setFrame:CGRectMake(destructiveButton.frame.origin.x, self.ActionSheetHeight, destructiveButton.frame.size.width, destructiveButton.frame.size.height)];
            
            if (otherButtonTitlesArray && otherButtonTitlesArray.count > 0) {
                self.ActionSheetHeight = self.ActionSheetHeight + destructiveButton.frame.size.height+kButtonMargin/2;
            }
            else{
                self.ActionSheetHeight = self.ActionSheetHeight + destructiveButton.frame.size.height+kButtonMargin;
            }
        }
        else{
            //当无title时
            if (otherButtonTitlesArray && otherButtonTitlesArray.count > 0) {
                self.ActionSheetHeight = self.ActionSheetHeight + destructiveButton.frame.size.height+(kButtonMargin+(kButtonMargin/2));
            }
            else{
                self.ActionSheetHeight = self.ActionSheetHeight + destructiveButton.frame.size.height+(2*kButtonMargin);
            }
        }
        [self.backgroundView addSubview:destructiveButton];
        
        self.indexNumber++;
    }
    
    if (otherButtonTitlesArray) {
        if (otherButtonTitlesArray.count > 0) {
            self.isShowOtherButton = YES;
            
            //当无title与destructionButton时
            if (self.isShowTitle == NO && self.isShowDestructiveButton == NO) {
                for (int i = 0; i<otherButtonTitlesArray.count; i++) {
                    UIButton *otherButton = [self creatOtherButtonWith:[otherButtonTitlesArray objectAtIndex:i] withPostion:i];
                    
                    otherButton.tag = self.indexNumber;
                    [otherButton addTarget:self action:@selector(clickOnButtonWith:) forControlEvents:UIControlEventTouchUpInside];
                    
                    if (i != otherButtonTitlesArray.count - 1) {
                        self.ActionSheetHeight = self.ActionSheetHeight + otherButton.frame.size.height+(kButtonMargin/2);
                    }
                    else{
                        self.ActionSheetHeight = self.ActionSheetHeight + otherButton.frame.size.height+(2*kButtonMargin);
                    }
                    
                    [self.backgroundView addSubview:otherButton];
                    
                    self.indexNumber++;
                }
            }
            
            //当有title或destructionButton时
            if (self.isShowTitle == YES || self.isShowDestructiveButton == YES) {
                for (int i = 0; i<otherButtonTitlesArray.count; i++) {
                    UIButton *otherButton = [self creatOtherButtonWith:[otherButtonTitlesArray objectAtIndex:i] withPostion:i];
                    
                    otherButton.tag = self.indexNumber;
                    [otherButton addTarget:self action:@selector(clickOnButtonWith:) forControlEvents:UIControlEventTouchUpInside];
                    [otherButton setFrame:CGRectMake(otherButton.frame.origin.x, self.ActionSheetHeight, otherButton.frame.size.width, otherButton.frame.size.height)];
                    
                    if (i != otherButtonTitlesArray.count - 1) {
                        self.ActionSheetHeight = self.ActionSheetHeight + otherButton.frame.size.height+(kButtonMargin/2);
                    }
                    else{
                        self.ActionSheetHeight = self.ActionSheetHeight + otherButton.frame.size.height+(kButtonMargin);
                    }
                    
                    [self.backgroundView addSubview:otherButton];
                    
                    self.indexNumber++;
                }
            }
        }
    }
    
    if (cancelButtonTitle) {
        self.isShowCancelButton = YES;
        
        UIButton *cancelButton = [self creatCancelButtonWith:cancelButtonTitle];
        
        cancelButton.tag = self.indexNumber;
        [cancelButton addTarget:self action:@selector(clickOnButtonWith:) forControlEvents:UIControlEventTouchUpInside];
        
        //当没title destructionButton otherbuttons时
        if (self.isShowTitle == NO && self.isShowDestructiveButton == NO && self.isShowOtherButton == NO) {
            self.ActionSheetHeight = self.ActionSheetHeight + cancelButton.frame.size.height+(2*kButtonMargin);
        }
        
        //当有title或destructionButton或otherbuttons时
        if (self.isShowTitle == YES || self.isShowDestructiveButton == YES || self.isShowOtherButton == YES) {
            [cancelButton setFrame:CGRectMake(cancelButton.frame.origin.x, self.ActionSheetHeight, cancelButton.frame.size.width, cancelButton.frame.size.height)];
            self.ActionSheetHeight = self.ActionSheetHeight + cancelButton.frame.size.height+kButtonMargin;
        }
        
        [self.backgroundView addSubview:cancelButton];
        
        self.indexNumber++;
    }
    
    [UIView animateWithDuration:ANIMATE_DURATION animations:^{
        [self.backgroundView setFrame:CGRectMake(kBackgroungMarginLeft, [UIScreen mainScreen].bounds.size.height-self.ActionSheetHeight, [UIScreen mainScreen].bounds.size.width-kBackgroungMarginLeft*2, self.ActionSheetHeight)];
    } completion:^(BOOL finished) {
    }];

    
}


- (id)initWithImageName:(NSString *)imgName delegate:(id<HYActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelTitle{
    self = [super init];
    if (self) {
        //初始化背景视图，添加手势
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        self.backgroundColor = WINDOW_COLOR;
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCancel)];
        [self addGestureRecognizer:tapGesture];
        
        if (delegate) {
            self.delegate = delegate;
        }
        [self createImageView:imgName cancelButtonTitle:cancelTitle];
    }
    return self;
}

- (void)showInView:(UIView *)view{
    
    [[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:self];
}

-(void) createImageView:(NSString *)imgName cancelButtonTitle:(NSString *)cancelTitle{
    
    self.ActionSheetHeight = 0;
    self.indexNumber = 0;
    self.isShowImageView = NO;
    self.isShowCancelButton = NO;
    
    self.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(kBackgroungMarginLeft, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width-kBackgroungMarginLeft*2, 0)];
//    self.backgroundView.layer.cornerRadius = kCornerRadius;
    self.backgroundView.backgroundColor = ACTIONSHEET_BACKGROUNDCOLOR;
    
    //给LXActionSheetView添加响应事件
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedBackGroundView)];
    [self.backgroundView addGestureRecognizer:tapGesture];
    
    [self addSubview:self.backgroundView];
    if (imgName) {
        self.isShowImageView = YES;
        UIImageView *imgv = [self createImageView:imgName];
        self.ActionSheetHeight = self.ActionSheetHeight + imgv.frame.size.height;
        [self.backgroundView addSubview:imgv];
    }
    
    if (cancelTitle) {
        self.isShowCancelButton = YES;
        UIButton *cancel = [self creatCancelButtonWith:cancelTitle];
        cancel.tag = self.indexNumber;
        [cancel addTarget:self action:@selector(clickOnButtonWith:) forControlEvents:UIControlEventTouchUpInside];
        self.ActionSheetHeight = self.ActionSheetHeight + cancel.frame.size.height;
        
        if (self.isShowImageView == YES) {
            [cancel setFrame:CGRectMake(kButtonMargin, self.ActionSheetHeight, kButtonWidth, kButtonHeight)];
            self.ActionSheetHeight = self.ActionSheetHeight + cancel.frame.size.height + kButtonMargin;
        }
        
        [self.backgroundView addSubview:cancel];
        self.indexNumber++;
    }
    
    [UIView animateWithDuration:ANIMATE_DURATION animations:^{
        [self.backgroundView setFrame:CGRectMake(kBackgroungMarginLeft, [UIScreen mainScreen].bounds.size.height-self.ActionSheetHeight, [UIScreen mainScreen].bounds.size.width-kBackgroungMarginLeft*2, self.ActionSheetHeight)];
    } completion:^(BOOL finished) {
    }];
}

/**
 *  创建一个button
 *
 *  @param cancelButtonTitle title
 *
 *  @return UIBtton
 */
- (UIButton *)creatCancelButtonWith:(NSString *)cancelButtonTitle
{
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(kButtonMargin, kButtonMargin, kButtonWidth, kButtonHeight)];
    cancelButton.layer.masksToBounds = YES;
    cancelButton.layer.cornerRadius = kCornerRadius;
    
    cancelButton.layer.borderWidth = kButtonBorderWidth;
    cancelButton.layer.borderColor = kButtonBorderColor;
    
    cancelButton.backgroundColor = CANCEL_BUTTON_COLOR;
    [cancelButton setTitle:cancelButtonTitle forState:UIControlStateNormal];
    cancelButton.titleLabel.font = kButtonTitleFont;
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    return cancelButton;
}

/**
 *  此方法返回一个Label，当作actionSheet 的 title
 *
 *  @param title 文字
 *
 *  @return UILabel
 */
- (UILabel *)creatTitleLabelWith:(NSString *)title
{
    UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(TITLE_INTERVAL_WIDTH, TITLE_INTERVAL_HEIGHT, TITLE_WIDTH, TITLE_HEIGHT)];
    titlelabel.backgroundColor = [UIColor clearColor];
    titlelabel.textAlignment = NSTextAlignmentCenter;
    titlelabel.shadowColor = [UIColor blackColor];
    titlelabel.shadowOffset = SHADOW_OFFSET;
    titlelabel.font = TITLE_FONT;
    titlelabel.text = title;
    titlelabel.textColor = [UIColor whiteColor];
    titlelabel.numberOfLines = TITLE_NUMBER_LINES;
    return titlelabel;
}

/**
 *  返回一个警告心性的按钮(红色背景显示)
 *
 *  @param destructiveButtonTitle title
 *
 *  @return UIButton
 */
- (UIButton *)creatDestructiveButtonWith:(NSString *)destructiveButtonTitle
{
    UIButton *destructiveButton = [[UIButton alloc] initWithFrame:CGRectMake(BUTTON_INTERVAL_WIDTH, kButtonMargin, BUTTON_WIDTH, BUTTON_HEIGHT)];
    destructiveButton.layer.masksToBounds = YES;
    destructiveButton.layer.cornerRadius = kCornerRadius;
    
    destructiveButton.layer.borderWidth = BUTTON_BORDER_WIDTH;
    destructiveButton.layer.borderColor = BUTTON_BORDER_COLOR;
    
    destructiveButton.backgroundColor = DESTRUCTIVE_BUTTON_COLOR;
    [destructiveButton setTitle:destructiveButtonTitle forState:UIControlStateNormal];
    destructiveButton.titleLabel.font = BUTTONTITLE_FONT;
    
    [destructiveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [destructiveButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    return destructiveButton;
}

/**
 *  创建一个正常形态的按钮，
 *
 *  @param otherButtonTitle title
 *  @param postionIndex     tag值，用来计算位置
 *
 *  @return UIButton
 */
- (UIButton *)creatOtherButtonWith:(NSString *)otherButtonTitle withPostion:(NSInteger )postionIndex
{
    UIButton *otherButton = [[UIButton alloc] initWithFrame:CGRectMake(BUTTON_INTERVAL_WIDTH, kButtonMargin + (postionIndex*(BUTTON_HEIGHT+(kButtonMargin/2))), BUTTON_WIDTH, BUTTON_HEIGHT)];
    otherButton.layer.masksToBounds = YES;
    otherButton.layer.cornerRadius = kCornerRadius;
    
    otherButton.layer.borderWidth = BUTTON_BORDER_WIDTH;
    otherButton.layer.borderColor = BUTTON_BORDER_COLOR;
    
    otherButton.backgroundColor = OTHER_BUTTON_COLOR;
    [otherButton setTitle:otherButtonTitle forState:UIControlStateNormal];
    otherButton.titleLabel.font = BUTTONTITLE_FONT;
    [otherButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [otherButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    return otherButton;
}

/**
 *  创建一个imageView
 *
 *  @param imgvName imageView.imageName
 *
 *  @return UIImageView
 */
-(UIImageView *)createImageView:(NSString *)imgvName{
    
    UIImageView *imgv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgvName]];
    imgv.frame = CGRectMake(kButtonMargin, kButtonMargin, kButtonWidth, self.frame.size.height/3.f);
    imgv.layer.masksToBounds = YES;
    imgv.layer.cornerRadius = kCornerRadius;
    imgv.layer.borderWidth = kButtonBorderWidth;
    imgv.layer.borderColor = kButtonBorderColor;
    return imgv;
}

- (void)tappedBackGroundView {
    //
}
- (void)tappedCancel {
    
    [UIView animateWithDuration:ANIMATE_DURATION animations:^{
        [self.backgroundView setFrame:CGRectMake(kBackgroungMarginLeft, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width-kBackgroungMarginLeft*2, 0)];
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

- (void)clickOnButtonWith:(UIButton *)button
{
    if (self.isShowDestructiveButton == YES) {
        if (self.delegate) {
            if (button.tag == 0) {
                if ([self.delegate respondsToSelector:@selector(didClickOnDestructiveButton)] == YES){
                    [self.delegate didClickOnDestructiveButton];
                }
            }
        }
    }
    
    if (self.isShowCancelButton == YES) {
        if (self.delegate) {
            if (button.tag == self.indexNumber-1) {
                if ([self.delegate respondsToSelector:@selector(didClickOnCancelButton)] == YES) {
                    [self.delegate didClickOnCancelButton];
                }
            }
        }
    }
    
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(didClickOnButtonIndex:)] == YES) {
            [self.delegate didClickOnButtonIndex:button.tag];
        }
    }
    
    [self tappedCancel];
}

@end