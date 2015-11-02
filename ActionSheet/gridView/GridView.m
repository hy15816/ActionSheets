//
//  GridView.m
//  ActionSheet
//
//  Created by AEF-RD-1 on 15/10/22.
//  Copyright (c) 2015年 hyIm. All rights reserved.
//

#import "GridView.h"

//======================GridView===============================
@interface GridView ()

@property (assign,nonatomic) CGFloat GridViewHeight;    //view 的总高度
@property (strong,nonatomic) UILabel *line;
@property (assign,nonatomic) id<GridViewDelegate>delegate;

@end

@implementation GridView

@synthesize buttonMarginLeft;
@synthesize buttonMarginTops;
@synthesize labelFont;
//@synthesize isShowLine;

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //
        if (!labelFont) {
            labelFont = [UIFont systemFontOfSize:14];
        }
        if (!buttonMarginLeft) {
            buttonMarginLeft = 10;
        }
        if (!buttonMarginTops) {
            buttonMarginTops = 10;
        }
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame delegate:(id<GridViewDelegate>)delegate buttonImage:(NSMutableArray *)imgArray title:(NSMutableArray *)titleArray numberOfRows:(NSInteger)numberOfRows{
    self = [self initWithFrame:frame];
    if (self) {
        //
        if (!numberOfRows) {
            numberOfRows = 4; //默认4个
        }
        
        if (delegate) {
            self.delegate = delegate;
        }
        NSInteger rows = imgArray.count %numberOfRows == 0?imgArray.count/numberOfRows:imgArray.count / numberOfRows + 1;//共有几行
        //每一个view的 W、H
        CGFloat viewW = (frame.size.width - buttonMarginLeft *(numberOfRows+1))/numberOfRows;
        CGFloat viewH = viewW *1.1;
        self.GridViewHeight = viewH *rows + buttonMarginTops *(rows);
        for (int i=0; i<imgArray.count; i++) {
            int y = i/numberOfRows;
            int x = i%numberOfRows;
            
            UIView *blView = [self createView:CGRectMake(buttonMarginLeft *(x+1) + x*viewW, y *(viewH + buttonMarginTops)+buttonMarginTops, viewW, viewH) image:[UIImage imageNamed:imgArray[i]] title:titleArray[i] tag:i];

            [self addSubview:blView];
            if (i == imgArray.count - 1) {

                if (self.delegate) {
                    if ([self.delegate respondsToSelector:@selector(gridViewWillUpdateFrame)]) {
                        if ([self.delegate gridViewWillUpdateFrame]) {
                            [self updateGridFrame];
                        }
                    }else{
                        NSLog(@"you must implementation delegate.gridViewUpdateFrame,if you will update your viewController's view ");
                    }                        
                }
            }
        }
        [self addLine];
        
    }
    
    return self;
}

- (void)addLine{
    self.line = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height-1, self.frame.size.width, .5)];
    self.line.backgroundColor = [UIColor blackColor];
    self.line.alpha = .35;
    self.line.hidden = YES;
    [self addSubview:self.line];
}

- (void)setIsShowLine:(BOOL)isShowLine{
    //self.isShowLine = isShowLine;
    if (isShowLine) {
        self.line.hidden = NO;
    }
}

/**
 *  更新GridView 的 Frame
 */
- (void)updateGridFrame{
    
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(gridView:didChangeSize:)]) {
            [self.delegate gridView:self didChangeSize:CGSizeMake(self.frame.size.width,self.GridViewHeight)];
        }
    }
}

/**
 *  创建一个view，包括button和label在view上，并按照button上&label下的格式排版
 *
 *  @param frame 此个view 的frame
 *  @param image button image
 *  @param title label text
 *
 *  @return UIView
 */
- (UIView *)createView:(CGRect)frame image:(UIImage *)image title:(NSString *)title tag:(NSInteger)tag{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    
    CGFloat labelH = labelFont.lineHeight;
    CGFloat buttonH = view.frame.size.height-labelH;
    CGFloat buttonW = buttonH;
    CGFloat buttonX = (view.frame.size.width - buttonW)/2;
    
    UILabel *label = [self createLabel:title];
    label.frame = CGRectMake(0, buttonH, view.frame.size.width, labelH);
    
    UIButton *button = [self createButton:image];
    button.frame = CGRectMake(buttonX, 0, buttonW, buttonH);
    button.tag = tag;
    
    [view addSubview:button];
    [view addSubview:label];
    return view;
}

-(UIButton *)createButton:(UIImage *)image{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor clearColor];
    [btn setImage:image forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

-(void)btnClick:(UIButton *)btn{
    
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(gridView:didClickButtonIndex:)]) {
            [self.delegate gridView:self didClickButtonIndex:btn.tag];
        }
    }

}

-(UILabel *)createLabel:(NSString *)text{

    UILabel *lab = [[UILabel alloc] init];
    lab.text = text;
    lab.textAlignment = NSTextAlignmentCenter;
    lab.backgroundColor = [UIColor clearColor];
    lab.font = labelFont;
    lab.textColor = [UIColor blackColor];
    
    
    return lab;
}

@end
