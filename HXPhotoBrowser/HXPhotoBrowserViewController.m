//
//  HXPhotoBrowserViewController.m
//  HXPhotoBrowser
//
//  Created by suin on 2018/8/15.
//  Copyright © 2018年 韩旭. All rights reserved.
//

#import "HXPhotoBrowserViewController.h"
#import "HXPhotoScrollView.h"
#import "HXPhotoImageView.h"
#import "UIImageView+SDWebImage.h"

#define kWIDTH [UIScreen mainScreen].bounds.size.width
#define kHEIGHT [UIScreen mainScreen].bounds.size.height

@interface HXPhotoBrowserViewController ()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIVisualEffectView *effectView;
@property (nonatomic, strong) HXPhotoImageView *currentImageView;
@property (nonatomic, strong) HXPhotoScrollView *photoScrollView;
@property (nonatomic, strong) NSArray *urlArray;
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
}

- (void)setPhotoScrollView{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    _photoScrollView = [[HXPhotoScrollView alloc] initWithFrame:CGRectMake(0, 0, kWIDTH, kHEIGHT)];
    [window addSubview:_photoScrollView];
    _photoScrollView.contentSize = CGSizeMake(kWIDTH * _urlArray.count, 0);
    for (int i = 0; i < _urlArray.count; i ++) {
        if (i == 0) {
            HXPhotoImageView *currentImageView = [[HXPhotoImageView alloc] initWithFrame:_selectedView.frame];
            [_photoScrollView addSubview:currentImageView];
            _currentImageView = currentImageView;
            [_currentImageView sd_setFadeImageWithURL:_urlArray[i]];
        } else{
            HXPhotoImageView *imageView = [[HXPhotoImageView alloc] initWithFrame:CGRectMake(i * kWIDTH, 150, kWIDTH, kHEIGHT - 300)];
            [_photoScrollView addSubview:imageView];
        }
    }
    
    UITapGestureRecognizer *bgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    bgTap.delegate = self;
    bgTap.numberOfTapsRequired = 1;
    bgTap.numberOfTouchesRequired = 1;
    [_photoScrollView addGestureRecognizer:bgTap];
}

- (void)setParentVC:(UIViewController *)parentVC{
    _parentVC = parentVC;
    
    CATransition  *transition = [CATransition animation];
    transition.duration = 0.1f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    [parentVC.view.window.layer addAnimation:transition forKey:nil];
    
    [self setModalPresentationStyle:UIModalPresentationOverFullScreen];
    parentVC.view.backgroundColor = [UIColor clearColor];
    parentVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    parentVC.providesPresentationContextTransitionStyle = YES;
    parentVC.definesPresentationContext = YES;
}

- (void)setUrlStrArray:(NSArray<NSString *> *)urlStrArray{
    NSMutableArray *urlArray = [NSMutableArray array];
    
    for (NSString *str in urlStrArray) {
        [urlArray addObject:[NSURL URLWithString:str]];
    }
    
    _urlArray = urlArray.copy;
    
    [self setPhotoScrollView];
}

- (void)show{
    [_parentVC presentViewController:self animated:NO completion:nil];
    
    [self transitionAnimation];
}

- (void)dismiss{
    [UIView animateWithDuration:0.25 animations:^{
        self.currentImageView.frame = self.selectedView.frame;
        self.effectView.alpha = 0;
        
    } completion:^(BOOL finished) {
        [self.photoScrollView removeFromSuperview];
        self.photoScrollView = nil;
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}

- (void)transitionAnimation{
    CGRect newFrame = CGRectMake(0, 150, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 300);
    [UIView animateWithDuration:0.25 animations:^{
        self.currentImageView.frame = newFrame;
    }];
}

@end
