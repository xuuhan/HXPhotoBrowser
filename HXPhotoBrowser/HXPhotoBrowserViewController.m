//
//  HXPhotoBrowserViewController.m
//  HXPhotoBrowser
//
//  Created by suin on 2018/8/15.
//  Copyright © 2018年 韩旭. All rights reserved.
//

#import "HXPhotoBrowserViewController.h"

#define kWIDTH [UIScreen mainScreen].bounds.size.width
#define kHEIGHT [UIScreen mainScreen].bounds.size.height

@interface HXPhotoBrowserViewController ()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIVisualEffectView *effectView;
@property (nonatomic, strong) UIImageView *singleImage;
@end

@implementation HXPhotoBrowserViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setEffectView];
}

- (void)setEffectView{
    UIBlurEffect *blurEffect =[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    _effectView =[[UIVisualEffectView alloc]initWithEffect:blurEffect];
    _effectView.frame = CGRectMake(0, 0, kWIDTH, kHEIGHT);
    [self.view addSubview:_effectView];
    
    UITapGestureRecognizer *bgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgTappedAction)];
    bgTap.delegate = self;
    bgTap.numberOfTapsRequired = 1;
    bgTap.numberOfTouchesRequired = 1;
    [_effectView addGestureRecognizer:bgTap];
}

- (void)setParentVC:(UIViewController *)parentVC{
    _parentVC = parentVC;
    
    CATransition  *transition = [CATransition animation];
    transition.duration = 0.3f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    [parentVC.view.window.layer addAnimation:transition forKey:nil];
    
    [self setModalPresentationStyle:UIModalPresentationOverFullScreen];
    parentVC.view.backgroundColor = [UIColor clearColor];
    parentVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    parentVC.providesPresentationContextTransitionStyle = YES;
    parentVC.definesPresentationContext = YES;
}

- (void)show{
    [_parentVC presentViewController:self animated:NO completion:nil];
    
    [self beginTransition];
}

- (void)bgTappedAction{
    [UIView animateWithDuration:0.2 animations:^{
        self.singleImage.frame = self.selectedView.frame;
        self.effectView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.singleImage removeFromSuperview];
        self.singleImage = nil;
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}

- (void)beginTransition{
    _singleImage = [[UIImageView alloc] initWithFrame:_selectedView.frame];
    
    if ([_selectedView isKindOfClass:[UIButton class]]) {
        UIButton *selectedBtn = (UIButton *)_selectedView;
        BOOL isImage = selectedBtn.currentImage;
        BOOL isBackImage = selectedBtn.currentBackgroundImage;
        if (isImage) {
            _singleImage.image = selectedBtn.currentImage;
        } else if (isBackImage){
            _singleImage.image = selectedBtn.currentBackgroundImage;
        } else return;
        
        [self transitionAnimation];
    }
    
    if ([_selectedView isKindOfClass:[UIImageView class]]) {
        UIImageView *selectedImage = (UIImageView *)_selectedView;
        if (selectedImage.image) {
            _singleImage.image = selectedImage.image;
        } else return;
        
        [self transitionAnimation];
    }
}

- (void)transitionAnimation{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:_singleImage];
    CGRect newFrame = CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 200);
    [UIView animateWithDuration:0.2 animations:^{
        self.singleImage.frame = newFrame;
    }];
}

@end
