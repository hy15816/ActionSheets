//
//  LoopViews.m
//  ActionSheet
//
//  Created by AEF-RD-1 on 15/10/23.
//  Copyright (c) 2015年 hyIm. All rights reserved.
//

#define kPageControlH   20
#define kLabelHeight    20
#define kLabelMarginLeft    10

#import "LoopView.h"

@interface LoopView ()<UIScrollViewDelegate>

@property (strong,nonatomic) NSMutableArray *loopImages;    //图片
@property (strong,nonatomic) NSMutableArray *loopTitles;    //标题
@property (assign,nonatomic) id<LoopViewDelegate> delegate;
@property (strong,nonatomic) UIScrollView *scrollView;
@property (strong,nonatomic) UIPageControl *pageControl;
@property (strong,nonatomic) NSTimer *scrollTimer;

@end

@implementation LoopView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //
        _loopTimeInterval = 1.5f;
        self.loopImages = [[NSMutableArray alloc] init];
        self.loopTitles = [[NSMutableArray alloc] init];
        
    }
    return self;
}

+ (instancetype)loopViewWithFrame:(CGRect)frame delegate:(id<LoopViewDelegate>)delegate imagesArray:(NSMutableArray *)images titleArray:(NSMutableArray *)titles{
    LoopView *loopView = [[self alloc] initWithFrame:frame];
    if (delegate) {
        loopView.delegate = delegate;
    }
    loopView.loopImages = images;
    loopView.loopTitles = titles;
    [loopView setupView];
    return loopView;
}

//若退出父view，停止定时器
- (void)willMoveToSuperview:(UIView *)newSuperview{
    if (!newSuperview) {
        [self.scrollTimer invalidate];
        self.scrollTimer = nil;
    }
}


- (void)setupView{
    
    CGFloat wid = self.frame.size.width;
    CGFloat hig = self.frame.size.height;
    NSInteger views = self.loopImages.count;
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, wid, hig)];
    _scrollView.backgroundColor = [UIColor whiteColor];
    [_scrollView setContentSize:CGSizeMake(wid * views, 0)];
    [_scrollView setPagingEnabled:YES];  //视图整页显示
    [_scrollView setBounces:YES]; //避免弹跳效果,避免把根视图露出来
    _scrollView.pagingEnabled = YES;//分页效果
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate = self;
    
    _pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(0,hig- kPageControlH ,wid, kPageControlH)];//居中显示
    if (self.loopTitles.count > 0) {
        _pageControl.frame = CGRectMake(wid-wid/4,hig-kPageControlH ,wid/4, kPageControlH);
    }
    _pageControl.backgroundColor=[UIColor clearColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor greenColor];
    _pageControl.numberOfPages=views;
    _pageControl.currentPage=0;
    [_pageControl addTarget:self action:@selector(CurPageChangeds:) forControlEvents:UIControlEventValueChanged];
    
    //添加图片和标题
    for (int i=0; i<views; i++) {
        //imgv tap
        UITapGestureRecognizer *tapGR=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchDownInimage)];
        //imgv
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(wid*i, 0, wid, hig)];
        imageview.userInteractionEnabled = YES;
        imageview.backgroundColor = [UIColor blueColor];
        [imageview setImage:[UIImage imageNamed:self.loopImages[i]]];
        //label view
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, hig - kLabelHeight, imageview.frame.size.width, kLabelHeight)];
        view.backgroundColor = [UIColor grayColor];
        view.alpha = .5;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kLabelMarginLeft, hig -kLabelHeight, imageview.frame.size.width-wid/4, kLabelHeight)];
        
        label.backgroundColor = [UIColor clearColor];
        label.textColor =[UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:16];
        if (self.loopTitles.count) {
            label.text = self.loopTitles[i];
        }
        
        [imageview addSubview:view];
        [imageview addSubview:label];
        [imageview addGestureRecognizer:tapGR];
        
        [_scrollView addSubview:imageview];
    }
    
    [self addSubview:_scrollView];
    [self addSubview:_pageControl];
    [self setupTimer];
}

/**
 *  设置滚动时间间隔
 *
 *  @param loopTimeInterval 时长
 */
- (void)setLoopTimeInterval:(CGFloat)loopTimeInterval{
    if (!loopTimeInterval) {
        loopTimeInterval = 1.5;
    }
    _loopTimeInterval = loopTimeInterval;
    
    [self setupTimer];
}

/**
 *  创建(重启)定时器
 */
- (void)setupTimer{
    
    [self.scrollTimer invalidate];
    self.scrollTimer = nil;
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:_loopTimeInterval target:self selector:@selector(autoScroll) userInfo:nil repeats:YES];
    self.scrollTimer = timer;
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

/**
 *  定时器方法
 */
- (void)autoScroll{
    
    NSLog(@"timer did running...");
    if (self.loopImages.count == 0) {
        return;
    }
    int currentIndex = fabs(_scrollView.contentOffset.x)/_scrollView.frame.size.width;
    int targetIndex = currentIndex + 1;
    if (targetIndex == self.loopImages.count) {// if最后一张,回到第一张
        targetIndex = 0;
        [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    
    //滚动至下一个
    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width * targetIndex, 0) animated:YES];
    
}

/**
 *  点击了图片
 */
- (void)touchDownInimage
{
    //
    if ([self.delegate respondsToSelector:@selector(loopView:didSelectItem:)]) {
        [self.delegate loopView:self didSelectItem:_pageControl.currentPage];
    }
    
}

-(void)CurPageChangeds:(UIPageControl *)pageCtrol{
    //点击小点，显示相应的view(图片)
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //设定y为0
    _scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, 0);
    //滚动图片，改变小点的显示位置
    int index = fabs(_scrollView.contentOffset.x) / _scrollView.frame.size.width;
    _pageControl.currentPage = index;
    
}

//在拖动过程中停止定时器，
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_scrollTimer invalidate];
    _scrollTimer = nil;
}
//拖动结束启动定时器
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self setupTimer];
}

@end
