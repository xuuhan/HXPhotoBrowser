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
#import "HXPhotoBrowserMacro.h"
#import <pthread.h>

@interface HXPhotoBrowserViewController ()<UIGestureRecognizerDelegate,UIScrollViewDelegate>
@property (nonatomic, strong) UIVisualEffectView *effectView;
@property (nonatomic, strong) HXPhotoImageView *currentImageView;
@property (nonatomic, strong) HXPhotoScrollView *photoScrollView;
@property (nonatomic, strong) NSArray *urlArray;
@property (nonatomic, assign) BOOL isCanPan;
@property (nonatomic, assign) CGFloat PanStartY;
@property (nonatomic, assign) CGFloat PanEndY;
@property (nonatomic, assign) CGFloat PanMoveY;
@property (nonatomic, assign) CGRect newFrame;
@end

@implementation HXPhotoBrowserViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setEffectView];
    
    CGRect newFrame = CGRectMake(0, 150, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 300);
    _newFrame = newFrame;
    
    _isCanPan = YES;
}

- (void)setEffectView{
    UIBlurEffect *blurEffect =[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    _effectView =[[UIVisualEffectView alloc]initWithEffect:blurEffect];
    _effectView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.view addSubview:_effectView];
}

- (void)setPhotoScrollView{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    _photoScrollView = [[HXPhotoScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [window addSubview:_photoScrollView];
    _photoScrollView.delegate = self;
    _photoScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * _urlArray.count, SCREEN_HEIGHT);
    
    [self addGesture];
    [self creatPhotoImageView];
}

- (void)creatPhotoImageView{
    for (int i = 0; i < _urlArray.count; i ++) {
        if (i == 0) {
            SDWebImageManager *manager = [SDWebImageManager sharedManager];
            [manager diskImageExistsForURL:_urlArray[i] completion:^(BOOL isInCache) {
                HXPhotoImageView *currentImageView = [[HXPhotoImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width * i, 150, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 300)];
                [self.photoScrollView addSubview:currentImageView];
                self.currentImageView = currentImageView;
                
                if (isInCache) {
                    self.currentImageView.frame = [self getStartRect];
                        [self.currentImageView finishProcess];
                        [self.currentImageView sd_setImageWithURL:self.urlArray[i]];
                        [UIView animateWithDuration:0.2 animations:^{
                            [self transitionAnimation];
                        }];
                } else{
                    
                    [self.currentImageView sd_setImageWithURL:self.urlArray[i] placeholderImage:[self getSelectedImg] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                        currentImageView.expectedSize = (CGFloat)expectedSize;
                        currentImageView.receivedSize = (CGFloat)receivedSize;
                    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                        [currentImageView finishProcess];
                    }];
                }
            }];
        } else{
            HXPhotoImageView *imageView = [[HXPhotoImageView alloc] initWithFrame:CGRectMake(i * SCREEN_WIDTH, 150, SCREEN_WIDTH, SCREEN_HEIGHT - 300)];
            [_photoScrollView addSubview:imageView];
        }
    }
}


- (void)addGesture{
    UITapGestureRecognizer *bgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    bgTap.numberOfTapsRequired = 1;
    bgTap.numberOfTouchesRequired = 1;
    [_photoScrollView addGestureRecognizer:bgTap];
    
    UITapGestureRecognizer *zoomTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoom:)];
    zoomTap.numberOfTapsRequired = 2;
    zoomTap.numberOfTouchesRequired = 1;
    [_photoScrollView addGestureRecognizer:zoomTap];
    [bgTap requireGestureRecognizerToFail:zoomTap];
    
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(move:)];
    [_photoScrollView addGestureRecognizer:recognizer];
    recognizer.delegate = self;
    _PanStartY = _currentImageView.frame.origin.y;
    _PanEndY = SCREEN_HEIGHT;
}

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {

    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
        if (translation.y <= 0 || _isCanPan == NO) {
            return NO;
        }
    return YES;
}


- (void)move:(UIPanGestureRecognizer *)recognizer{
    if(_isCanPan == NO) return;

    CGPoint pt = [recognizer translationInView:_photoScrollView];
    
    _currentImageView.frame = CGRectMake(_currentImageView.frame.origin.x + pt.x, _currentImageView.frame.origin.y + pt.y, _currentImageView.frame.size.width, _currentImageView.frame.size.height);
    
    _PanMoveY += pt.y;
    
    [recognizer setTranslation:CGPointMake(0, 0) inView:_photoScrollView];
    
    if (recognizer.state == UIGestureRecognizerStateChanged){
        _effectView.alpha = 1 - _PanMoveY / (_PanEndY - _PanStartY) * 1.5;
        if (pt.y > 0) {
            _currentImageView.transform = CGAffineTransformScale(_currentImageView.transform, kHXPhotoBrowserTransformShrink, kHXPhotoBrowserTransformShrink);
        } else if (pt.y < 0 && _PanMoveY > 0){
            _currentImageView.transform = CGAffineTransformScale(_currentImageView.transform, kHXPhotoBrowserTransformAmplify, kHXPhotoBrowserTransformAmplify);
        }
    } else if (recognizer.state == UIGestureRecognizerStateEnded){
        if (_currentImageView.frame.origin.y < SCREEN_HEIGHT * kHXPhotoBrowserDisMissValue) {
            [UIView animateWithDuration:0.2 animations:^{
                self.currentImageView.frame = self.newFrame;
                self.effectView.alpha = 1;
            }];
            _PanMoveY = 0;
        } else{
            [self dismiss];
        }
    }
}

- (void)zoom:(UITapGestureRecognizer *)recognizer{
    CGPoint touchPoint = [recognizer locationInView:_photoScrollView];
    if (_photoScrollView.zoomScale <= kHXPhotoBrowserZoomMin) {
        _photoScrollView.maximumZoomScale = kHXPhotoBrowserZoomMid;
        [_photoScrollView zoomToRect:CGRectMake(touchPoint.x + _photoScrollView.contentOffset.x, touchPoint.y + _photoScrollView.contentOffset.y, 5, 5) animated:YES];
        _isCanPan = NO;
    } else {
        [_photoScrollView setZoomScale:kHXPhotoBrowserZoomMin animated:YES];
        _isCanPan = YES;
    }
}

- (CGPoint)centerOfScrollViewContent:(UIScrollView *)scrollView
{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    CGPoint center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                       scrollView.contentSize.height * 0.5 + offsetY);
    return center;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _currentImageView;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view{
    _isCanPan = NO;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    _photoScrollView.maximumZoomScale = kHXPhotoBrowserZoomMax;
    _currentImageView.center = [self centerOfScrollViewContent:scrollView];
    
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    if (scale <= kHXPhotoBrowserZoomMin || self.currentImageView.frame.size.height <= SCREEN_HEIGHT) {
        [UIView animateWithDuration:0.3 animations:^{
            [self.currentImageView setCenter:CGPointMake(self.currentImageView.center.x,scrollView.center.y)];
        }];
    }
    
    if (scale <= kHXPhotoBrowserZoomMin) {
        _isCanPan = YES;
    }
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
}


- (void)show{
    [self setPhotoScrollView];
    
    [_parentVC presentViewController:self animated:NO completion:nil];
    
}

- (void)dismiss{
    [UIView animateWithDuration:0.15 animations:^{
        self.currentImageView.frame = [self getStartRect];
        self.effectView.alpha = 0;
        
    } completion:^(BOOL finished) {
        [self.photoScrollView removeFromSuperview];
        self.photoScrollView = nil;
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}

- (void)transitionAnimation{
    
    [UIView animateWithDuration:0.25 animations:^{
        self.currentImageView.frame = self.newFrame;
    }];
}

- (UIImage *)getSelectedImg{
    UIImage *image = [UIImage new];
    if ([_selectedView isKindOfClass:[UIImageView class]] ) {
        UIImageView *img = (UIImageView *)_selectedView;
        image = img.image;
    }
    
    if ([_selectedView isKindOfClass:[UIButton class]]) {
        UIButton *btn = (UIButton *)_selectedView;
        image = btn.currentImage ? btn.currentImage : btn.currentBackgroundImage;
    }
    
    return image;
}

- (CGRect)getStartRect{
    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
    CGRect startRact = [self.selectedView convertRect:self.selectedView.bounds toView:window];
    startRact.origin.y += StatusBarHeight;
    
    return startRact;
}

@end
