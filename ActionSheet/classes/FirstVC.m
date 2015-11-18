//
//  FirstVC.m
//  ActionSheet
//
//  Created by AEF-RD-1 on 15/11/5.
//  Copyright © 2015年 hyIm. All rights reserved.
//
#define kMyHeadPortraitName @"myImageName"

#import "FirstVC.h"
#import "HYPhotoPickerView.h"

@interface FirstVC ()<UIScrollViewDelegate>

@property (strong,nonatomic) UIScrollView *scrolView;
@property (strong,nonatomic) UIImageView *showImage;

@property (strong, nonatomic) IBOutlet UIImageView *iconImageView;
- (IBAction)iconImageViewTap:(UITapGestureRecognizer *)sender;

@end

@implementation FirstVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    _scrolView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    
    _showImage = [[UIImageView alloc] initWithFrame:self.iconImageView.frame];
    _showImage.image = [UIImage imageNamed:@"icon_user_df"];
    
    [_scrolView addSubview:_showImage];
    _scrolView.contentSize = self.iconImageView.image.size;
    _scrolView.delegate = self;
    _scrolView.maximumZoomScale = 2.0;
    _scrolView.minimumZoomScale = 0.5;
    
    [self.view addSubview:_scrolView];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imageFilePath = [documentsDirectory stringByAppendingPathComponent:kMyHeadPortraitName];
    NSLog(@"imageFile->>%@",imageFilePath);
    UIImage *selfPhoto = [UIImage imageWithContentsOfFile:imageFilePath];
    if (!selfPhoto) {
        selfPhoto = [UIImage imageNamed:@"account_icon"];
    }
    self.iconImageView.image = selfPhoto;

}


#pragma  mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return _showImage;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view{
    
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    
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

- (IBAction)iconImageViewTap:(UITapGestureRecognizer *)sender {
    
//    [UIView animateWithDuration:.4 animations:^{
//    
//        self.iconImageView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height *.7);
//    }];
    
    /*
    HYPhotoPickerView *photo = [HYPhotoPickerView shard];
    [photo showActionInViewController:self completion:^(UIImage *image){
//        dispatch_async(dispatch_get_main_queue(), ^{
//            self.iconImageView.image = image;
//        });
        [self saveImageToLocal:image];
    } cancelBlock:^{
        NSLog(@"cancel");
    }];
    */
}

//保存到本地
- (void)saveImageToLocal:(UIImage *)image{
    
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imageFilePath = [documentsDirectory stringByAppendingPathComponent:kMyHeadPortraitName];
    NSLog(@"imageFile->>%@",imageFilePath);
    success = [fileManager fileExistsAtPath:imageFilePath];
    if(success) {
        success = [fileManager removeItemAtPath:imageFilePath error:&error];
    }
    
    //UIImage *smallImage = [self thumbnailWithImageWithoutScale:image size:CGSizeMake(80, 80)];
    [UIImageJPEGRepresentation(image, 1.0f) writeToFile:imageFilePath atomically:YES];//写入文件
    UIImage *userIcon = [UIImage imageWithContentsOfFile:imageFilePath];//读取图片文件
    dispatch_async(dispatch_get_main_queue(), ^{
        self.iconImageView.image = userIcon;
    });
}

//保持图片原来的长宽比，生成一个缩略图
- (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize
{
    UIImage *newimage;
    if (nil == image) {
        newimage = nil;
    }
    else{
        CGSize oldsize = image.size;
        CGRect rect;
        if (asize.width/asize.height > oldsize.width/oldsize.height) {
            rect.size.width = asize.height*oldsize.width/oldsize.height;
            rect.size.height = asize.height;
            rect.origin.x = (asize.width - rect.size.width)/2;
            rect.origin.y = 0;
        }
        else{
            rect.size.width = asize.width;
            rect.size.height = asize.width*oldsize.height/oldsize.width;
            rect.origin.x = 0;
            rect.origin.y = (asize.height - rect.size.height)/2;
        }
        
        UIGraphicsBeginImageContext(asize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
        [image drawInRect:rect];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newimage;
}



@end
