//
//  HYPhotoPickerManager.m
//  ActionSheet
//
//  Created by AEF-RD-1 on 15/11/5.
//  Copyright © 2015年 hyIm. All rights reserved.
//

#import "HYPhotoPickerView.h"

@interface HYPhotoPickerView ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>

@property (strong,nonatomic) UIViewController *formVC;
@property (strong,nonatomic) PhotoPickerCompelitionBlock    compelitionBlock;
@property (strong,nonatomic) PhotoPickerCancelBlock         cancelBlock;

@end

@implementation HYPhotoPickerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (HYPhotoPickerView *)shard{
    static HYPhotoPickerView *photo = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        photo = [[self alloc] init];
    });
    return photo;
}
- (void)showActionInViewController:(UIViewController *)formController completion:(PhotoPickerCompelitionBlock)completion cancelBlock:(PhotoPickerCancelBlock)cancelBlock{
    
    self.compelitionBlock = completion;
    self.cancelBlock = cancelBlock;
    self.formVC = formController;
    self.formVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    //子线程运行
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIActionSheet *actionSheet = nil;
        actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选取", nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            [actionSheet showInView:formController.view];
        });
        
    });
    return;
    
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.navigationBar.tintColor = [UIColor blackColor];

    switch (buttonIndex) {
        case 0:
            //拍照
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;//图片源为相机
            [self.formVC presentViewController:picker animated:YES completion:^{}];
            break;
        case 1:
            //相册选取
            picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;//图片源为相册;
            [self.formVC presentViewController:picker animated:YES completion:^{}];
            break;
            
        default:
            break;
    }
    
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    /**
     *  UIImagePickerControllerOriginalImage    选择的整张图片（原始图片）
     *  UIImagePickerControllerEditedImage      裁剪部分，(选取框类型)
     */
    UIImage *img = [info objectForKey:UIImagePickerControllerEditedImage];//选取框类型
    if (img && self.compelitionBlock) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.compelitionBlock(img);
        });
        
        
    }
    
    [self.formVC dismissViewControllerAnimated:YES completion:nil];
    return;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    if (self.cancelBlock) {
        self.cancelBlock();
    }
    [self.formVC dismissViewControllerAnimated:YES completion:nil];
    return;
}



@end
