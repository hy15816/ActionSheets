//
//  FirstVC.m
//  ActionSheet
//
//  Created by AEF-RD-1 on 15/10/27.
//  Copyright (c) 2015年 hyIm. All rights reserved.
//

#import "FirstVC.h"
#import "Toast+UIView.h"

@interface FirstVC ()
{
    UIView *_yView;
    UIButton *_activitybutton;
    BOOL _isShowActivity;
}
- (IBAction)make1:(id)sender;
- (IBAction)make2:(id)sender;
- (IBAction)make3:(id)sender;
- (IBAction)make4:(id)sender;
- (IBAction)make5:(id)sender;

- (IBAction)activity1:(id)sender;
- (IBAction)activity2:(id)sender;
- (IBAction)hideActivity:(id)sender;

- (IBAction)showToast:(id)sender;
- (IBAction)showToast2:(id)sender;

@end

@implementation FirstVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _isShowActivity = NO;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)make1:(id)sender {
    [self.view makeToast:@"self.view"];
}

- (IBAction)make2:(id)sender {
    [self.view makeToast:@"self.view" duration:3.f position:@"top"];
    //[self.view makeToast:@"self.view" duration:3.f position:@"center"];
    //[self.view makeToast:@"self.view" duration:3.f position:@"bottom"];
}

- (IBAction)make3:(id)sender {
    [self.view makeToast:@"self.view" duration:3.f position:@"center" title:@"title"];
}

- (IBAction)make4:(id)sender {
    [self.view makeToast:@"self.view" duration:2.f position:@"center" title:@"title" image:[UIImage imageNamed:@"png_a_0"]];
}

- (IBAction)make5:(id)sender {
    [self.view makeToast:@"self.view" duration:3.f position:@"bottom" image:[UIImage imageNamed:@"png_a_0"]];
}

- (IBAction)activity1:(id)sender {
//    if (!_isShowActivity) {
//        [_activitybutton setTitle:@"hide acti" forState:UIControlStateNormal];
//        [self.view makeToastActivity:_activitybutton];
//    }
}

- (IBAction)activity2:(id)sender {
}

- (IBAction)hideActivity:(id)sender {
    [self.view hideToastActivity];
}
- (IBAction)showToast:(id)sender {
    UIView *oView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
    oView.backgroundColor = [UIColor orangeColor];
    [self.view showToast:oView];
}

- (IBAction)showToast2:(id)sender {
    
    UIView *oView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
    oView.backgroundColor = [UIColor orangeColor];
    [self.view showToast:oView duration:2.f position:@"center"];
}
@end
