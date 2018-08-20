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

@interface HXPhotoBrowserViewController ()<UIGestureRecognizerDelegate,UIScrollViewDelegate>
@property (nonatomic, strong) UIVisualEffectView *effectView;
@property (nonatomic, strong) HXPhotoImageView *currentImageView;
@property (nonatomic, strong) HXPhotoScrollView *photoScrollView;
@property (nonatomic, strong) NSArray *urlArray;
@property (nonatomic, assign) CGFloat PanStartY;
@property (nonatomic, assign) CGFloat PanEndY;
@property (nonatomic, assign) CGFloat PanMoveY;
@end

@implementation HXPhotoBrowserViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setEffectView];
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
    for (int i = 0; i < _urlArray.count; i ++) {
        if (i == 0) {
            HXPhotoImageView *currentImageView = [[HXPhotoImageView alloc] initWithFrame:_selectedView.frame];
            [_photoScrollView addSubview:currentImageView];
            _currentImageView = currentImageView;
            [_currentImageView sd_setFadeImageWithURL:_urlArray[i]];
        } else{
            HXPhotoImageView *imageView = [[HXPhotoImageView alloc] initWithFrame:CGRectMake(i * SCREEN_WIDTH, 150, SCREEN_WIDTH, SCREEN_HEIGHT - 300)];
            [_photoScrollView addSubview:imageView];
        }
    }
    
    [self addGesture];
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
        if (translation.y <= 0) {
            return NO;
        }
    return YES;
}


- (void)move:(UIPanGestureRecognizer *)recognizer{
    CGPoint pt = [recognizer translationInView:_photoScrollView];
    
    _currentImageView.frame = CGRectMake(_currentImageView.frame.origin.x + pt.x, _currentImageView.frame.origin.y + pt.y, _currentImageView.frame.size.width, _currentImageView.frame.size.height);
    
    _PanMoveY += pt.y;
    
    [recognizer setTranslation:CGPointMake(0, 0) inView:_photoScrollView];
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        NSLog(@"开始");
    } else if (recognizer.state == UIGestureRecognizerStateChanged){
        NSLog(@"拖动");
        NSLog(@"-----%f",_PanMoveY);
        _effectView.alpha = 1 - _PanMoveY / (_PanEndY - _PanStartY);
    } else if (recognizer.state == UIGestureRecognizerStateEnded){
        if (_currentImageView.frame.origin.y < SCREEN_HEIGHT * 0.65) {
            [UIView animateWithDuration:0.2 animations:^{
                self.currentImageView.frame = CGRectMake(0, 150, SCREEN_WIDTH, SCREEN_HEIGHT - 300);
            }];
            _effectView.alpha = 1;
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
    } else {
        [_photoScrollView setZoomScale:kHXPhotoBrowserZoomMin animated:YES];
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
