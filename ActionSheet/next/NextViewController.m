//
//  NextViewController.m
//  ActionSheet
//
//  Created by AEF-RD-1 on 15/10/23.
//  Copyright (c) 2015年 hyIm. All rights reserved.
//

#import "NextViewController.h"
#import "LoopView.h"

@interface NextViewController ()<LoopViewDelegate,UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *scroll;

@end

@implementation NextViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1.使用LoopView
    NSMutableArray *images = [[NSMutableArray alloc] initWithObjects:@"h1",@"h4",@"h3",@"h4", nil];
    NSMutableArray *titles = [[NSMutableArray alloc] initWithObjects:@"title1",@"这里显示标题",@"qweoiudnuisahdiushf，，，，foie",@"这里显示对应的图片的说明，",nil];
    LoopView *loopView = [LoopView loopViewWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 200) delegate:self imagesArray:images titleArray:titles];
    //loopView.loopTimeInterval = 3;
    [self.view addSubview:loopView];

//    LoopView *loopView2 = [LoopView loopViewWithFrame:CGRectMake(0, 320, self.view.frame.size.width, 200) delegate:self imagesArray:images titleArray:nil];
//    loopView2.loopTimeInterval = 3;
//    [self.view addSubview:loopView2];
}

#pragma mark - LoopViewDelegate
- (void)loopView:(LoopView *)loopView didSelectItem:(NSInteger)index{
    
    NSLog(@"clicl item index %ld",(long)index);
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
