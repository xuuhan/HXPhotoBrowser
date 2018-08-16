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
@property (nonatomic, strong) UIImageView *singleImg;
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
        self.singleImg.frame = self.selectedView.frame;
        self.effectView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.singleImg removeFromSuperview];
        self.singleImg = nil;
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}

- (void)beginTransition{
    _singleImg = [[UIImageView alloc] initWithFrame:_selectedView.frame];
    
    if ([_selectedView isKindOfClass:[UIButton class]]) {
        UIButton *selectedBtn = (UIButton *)_selectedView;
        BOOL isImg = selectedBtn.currentImage;
        BOOL isBackImg = selectedBtn.currentBackgroundImage;
        if (isImg) {
            self.singleImg.image = selectedBtn.currentImage;
        } else if (isBackImg){
            self.singleImg.image = selectedBtn.currentBackgroundImage;
        } else return;
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:_singleImg];
        CGRect newFrame = CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 200);
        [UIView animateWithDuration:0.2 animations:^{
            self.singleImg.frame = newFrame;
        }];

    }
}

@end
