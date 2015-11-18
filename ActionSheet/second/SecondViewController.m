//
//  SecondViewController.m
//  ActionSheet
//
//  Created by AEF-RD-1 on 15/11/3.
//  Copyright © 2015年 hyIm. All rights reserved.
//

#import "SecondViewController.h"
#import "CustomSegueUnWind.h"

@interface SecondViewController ()
- (IBAction)backItemClick:(UIBarButtonItem *)sender;

@property (strong,nonatomic) IBOutlet UIBarButtonItem *backItem;
@end

@implementation SecondViewController

-(void)viewOutAnimation:(UIStoryboardSegue *)sender{
    if (sender) {
        if ([sender.identifier isEqualToString:@"secondVCUnWind"]) {
            //CustomSegueUnWind *unwind = [];
            UIColor *color = self.view.backgroundColor;
            self.view.backgroundColor = [UIColor redColor];
            
            [UIView animateWithDuration:1.0 animations:^{
                self.view.backgroundColor = color;
            }];
        }
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (IBAction)backItemClick:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}
@end
