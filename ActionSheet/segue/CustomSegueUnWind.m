//
//  CustomSegueUnWind.m
//  ActionSheet
//
//  Created by AEF-RD-1 on 15/11/3.
//  Copyright © 2015年 hyIm. All rights reserved.
//

#import "CustomSegueUnWind.h"

@implementation CustomSegueUnWind

- (void)perform{
    UIView *firstV = self.sourceViewController.view;
    UIView *secondV = self.destinationViewController.view;
    
    //CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window insertSubview:secondV aboveSubview:firstV];
    
    [UIView animateWithDuration:.4 animations:^{
        //firstV.frame = CGRectOffset(firstV.frame, 0.0, -screenH);
        //secondV.frame = CGRectOffset(secondV.frame, 0.0, -screenH);
        firstV.frame = CGRectMake(0, 0, firstV.frame.size.width, firstV.frame.size.height);
        secondV.frame = CGRectMake(-secondV.frame.size.width, 0, secondV.frame.size.width, secondV.frame.size.height);
    } completion:^(BOOL finish){
        NSLog(@"finish");
        [self.sourceViewController dismissViewControllerAnimated:YES completion:^{}];
    }];
}


@end
