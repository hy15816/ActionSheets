//
//  CusStoryboardSegue.m
//  ActionSheet
//
//  Created by AEF-RD-1 on 15/11/3.
//  Copyright © 2015年 hyIm. All rights reserved.
//

#import "CusStoryboardSegue.h"

@implementation CusStoryboardSegue

- (void)perform{
    
    //[self method1];
    [self method2];
}

- (void)method1{
    UIViewController *dst = [self destinationViewController];
    UIViewController *src = [self sourceViewController];
    [dst viewWillAppear:NO];
    [dst viewDidAppear:NO];
    
    
    
    CGRect original = dst.view.frame;
    /*
     UIGraphicsBeginImageContextWithOptions(CGSizeMake(dst.view.frame.size.width, dst.view.frame.size.height), YES, 0);     //设置截屏大小
     [[dst.view layer] renderInContext:UIGraphicsGetCurrentContext()];
     UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
     UIGraphicsEndImageContext();
     CGImageRef imageRef = viewImage.CGImage;
     CGRect rect = src.view.frame;//这里可以设置想要截图的区域
     CGImageRef imageRefRect =CGImageCreateWithImageInRect(imageRef, rect);
     UIImage *sendImage = [[UIImage alloc] initWithCGImage:imageRefRect];
     [[UIApplication sharedApplication].windows objectAtIndex:0].backgroundColor =[UIColor colorWithPatternImage:sendImage];
     */
    
    //dst.view.frame = CGRectMake(dst.view.frame.origin.x, dst.view.frame.size.height, dst.view.frame.size.width, dst.view.frame.size.height);
    dst.view.frame = CGRectMake(-dst.view.frame.origin.x, 0, dst.view.frame.size.width, dst.view.frame.size.height);
    [src.view addSubview:dst.view];
    
    //执行动画
    [UIView beginAnimations:nil context:nil];
    src.view.frame = CGRectMake(src.view.frame.size.width*1.5, src.view.frame.origin.y, src.view.frame.size.width, src.view.frame.size.height);
    dst.view.frame = CGRectMake(original.origin.x, original.origin.y, original.size.height, original.size.width);
    [UIView commitAnimations];
    
    [self performSelector:@selector(animationDone:) withObject:dst afterDelay:.1f];
}

- (void)animationDone:(id)vc{
    
    UIViewController *dst = (UIViewController*)vc;
    UINavigationController *nav = [[self sourceViewController] navigationController];
    [nav popViewControllerAnimated:NO];
    [nav pushViewController:dst animated:NO];
    [self sourceViewController];
}


- (void)method2{
    
    UIView *secondV = self.destinationViewController.view;
    UIView *firstV = self.sourceViewController.view;
    
    CGFloat screenW = [[UIScreen mainScreen] bounds].size.width;
    CGFloat screenH = [[UIScreen mainScreen] bounds].size.height;
    
    secondV.frame = CGRectMake(-screenW, 0, screenW, screenH);
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window insertSubview:secondV aboveSubview:firstV];
    
    [UIView animateWithDuration:.4 animations:^{
        //firstV.frame = CGRectOffset(firstV.frame, 0.0, -screenH);
        //secondV.frame = CGRectOffset(secondV.frame, 0.0, -screenH);
        firstV.frame = CGRectMake(firstV.frame.size.width/2, 0, firstV.frame.size.width, firstV.frame.size.height);
        secondV.frame = CGRectMake(0, 0, secondV.frame.size.width, secondV.frame.size.height);
    } completion:^(BOOL finish){
        
        NSLog(@"finish:%d",finish);
        //UINavigationController *nav = [self.sourceViewController navigationController];
//        [self.sourceViewController presentViewController:nav animated:false completion:nil];
        //[self.sourceViewController pushViewController:self.destinationViewController animated:YES];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self.destinationViewController];
        [self.sourceViewController presentViewController:nav animated:NO completion:nil];
    }];
    
    
    
}

@end
