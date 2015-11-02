//
//  ViewController.m
//  ActionSheet
//
//  Created by AEF-RD-1 on 15/10/20.
//  Copyright (c) 2015年 hyIm. All rights reserved.
//

#define kMainStoryboard [UIStoryboard storyboardWithName:@"Main" bundle:nil]

#import "ViewController.h"
#import "YActionSheet.h"
#import "GridView.h"

@interface ViewController ()<HYActionSheetDelegate,UIActionSheetDelegate,GridViewDelegate>
{
    UIView *v;
}
@property (strong,nonatomic) YActionSheet *actionSheet;

- (IBAction)showImage:(UIButton *)sender;
- (IBAction)showDestructive:(id)sender;
- (IBAction)showAnyBtn:(id)sender;
- (IBAction)showTitleAndAnyBtn:(id)sender;
- (IBAction)showTitleAndDestructiveBtn:(id)sender;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addGridView];
}

- (void)addGridView{
    
    NSMutableArray *imgArray = [[NSMutableArray alloc] initWithObjects:@"png_a_0",@"png_a_0", @"png_a_0",@"png_a_0",@"png_a_0",nil];
    NSMutableArray *labArray = [[NSMutableArray alloc] initWithObjects:@"1111",@"2222",@"3333",@"4444",@"5555", nil];
    
    GridView *gridView =[[GridView alloc] initWithFrame:CGRectMake(0,self.view.frame.size.height-200,self.view.frame.size.width, 150) delegate:self buttonImage:imgArray title:labArray numberOfRows:4];
    gridView.isShowLine = YES;
    gridView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:gridView];
    
    v = [[UIView alloc] initWithFrame:CGRectMake(0, gridView.frame.size.height+gridView.frame.origin.y, self.view.frame.size.width, 20)];
    v.backgroundColor = [UIColor yellowColor];
    //[self.view addSubview:v];
}

#pragma mark - GridViewDelegate
- (BOOL)gridViewWillUpdateFrame{
    
    return YES;
}
- (void)gridView:(GridView *)gridView didClickButtonIndex:(NSInteger)buttonIndex{
    NSLog(@"GridView - buttonIndex %ld",(long)buttonIndex);
    UIViewController *control;
    switch (buttonIndex) {
        case 0:
            //
            break;
        case 1:
            control = [kMainStoryboard instantiateViewControllerWithIdentifier:@"FirstVCIDF"];
            break;
            
        default:
            break;
    }
    if (control) {
        [self.navigationController pushViewController:control animated:YES];
    }
    
}

- (void)gridView:(GridView *)gridView didChangeSize:(CGSize)size{
    [UIView animateWithDuration:.25 animations:^{
        gridView.frame = CGRectMake(0, self.view.frame.size.height-200, size.width, size.height);
        v.frame = CGRectMake(0, gridView.frame.size.height+gridView.frame.origin.y, self.view.frame.size.width, 20);
    }];
    
}

#pragma mark - button click
- (IBAction)showImage:(UIButton *)sender {
    self.actionSheet = [[YActionSheet alloc] initWithImageName:@"csy_xsz" delegate:self cancelButtonTitle:@"关闭"];
    [self.actionSheet showInView:self.view];
}

- (IBAction)showDestructive:(id)sender {
    self.actionSheet = [[YActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:@[@"手机",@"相册",@"更多"]];
    [self.actionSheet showInView:self.view];
}

- (IBAction)showAnyBtn:(id)sender {
    self.actionSheet = [[YActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"QQ注册",@"微博注册",@"微信注册"]];
    [self.actionSheet showInView:self.view];
}

- (IBAction)showTitleAndAnyBtn:(id)sender {
    self.actionSheet = [[YActionSheet alloc]initWithTitle:@"选择登录方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"QQ登录",@"微博登录",@"微信登录"]];
    [self.actionSheet showInView:self.view];
}

- (IBAction)showTitleAndDestructiveBtn:(id)sender {
    self.actionSheet = [[YActionSheet alloc] initWithTitle:@"确定退出?确定退出?确定退出?确定退出?确定退出?确定退出?确定退出?" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"退出登录" otherButtonTitles:nil];
    [self.actionSheet showInView:self.view];
    
}

#pragma mark - HYActionSheetDelegate
- (void)didClickOnButtonIndex:(NSInteger)buttonIndex{
    
    NSLog(@"click buttonTndex %ld",(long)buttonIndex);
}

- (void)didClickOnCancelButton{
    
    NSLog(@"click cancel button");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
