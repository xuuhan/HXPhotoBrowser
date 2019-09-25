//
//  HXPhotoBrowserViewController.m
//  HXPhotoBrowser
//
//  Created by suin on 2018/8/15.
//  Copyright © 2018年 韩旭. All rights reserved.
//

#import "HXPhotoBrowserViewController.h"
#import "HXPhotoImageView.h"
#import "HXUIImageView+SDWebImage.h"
#import "HXPhotoBrowserMacro.h"
#import <pthread.h>

typedef NS_ENUM(NSInteger,PhotoCount){
    PhotoCountSingle,
    PhotoCountMultiple
};

@interface HXPhotoBrowserViewController ()<UIGestureRecognizerDelegate,UIScrollViewDelegate,HXPhotoImageViewDelegate>
@property (nonatomic, strong) UIVisualEffectView *effectView;
@property (nonatomic, strong) HXPhotoImageView *currentImageView;
@property (nonatomic, strong) HXPhotoImageView *firstImageView;
@property (nonatomic, strong) UIScrollView *photoScrollView;
@property (nonatomic, strong) NSArray <NSURL *>*urlArray;
@property (nonatomic, strong) NSArray *heightArray;
@property (nonatomic, strong) NSArray <HXPhotoImageView *>*imageViewArray;
@property (nonatomic, assign) BOOL isCanPan;
@property (nonatomic, assign) CGFloat panStartY;
@property (nonatomic, assign) CGFloat panEndY;
@property (nonatomic, assign) CGFloat panMoveY;
@property (nonatomic, assign) PhotoCount photoCount;
@property (nonatomic, assign) CGFloat pageWidth;
@property (nonatomic, assign) NSInteger firstIndex;
@property (nonatomic, strong) UILabel *indexLabel;
@property (nonatomic, assign) BOOL isOverHeight;
@end

@implementation HXPhotoBrowserViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setEffectView];
    _isCanPan = YES;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        _config = [HXPhotoConfig new];
    }
    return self;
}

- (void)setEffectView{
    UIBlurEffect *blurEffect =[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    _effectView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
    _effectView.frame = CGRectMake(0, 0, kHXSCREEN_WIDTH, kHXSCREEN_HEIGHT);
    [self.view addSubview:_effectView];
}

- (void)setIndexLabel{
    if (!_indexLabel) {
        _indexLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kHXSCREEN_HEIGHT - 70, kHXSCREEN_WIDTH, 20)];
        [[self mainWindow] addSubview:_indexLabel];
        _indexLabel.textColor = [UIColor whiteColor];
        _indexLabel.font = [UIFont systemFontOfSize:14];
        _indexLabel.textAlignment = NSTextAlignmentCenter;
        [self setIndexTitleWithIndex:_currentIndex];
    }
}

- (void)setPhotoScrollView{
    _photoScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kHXSCREEN_WIDTH + kHXPhotoBrowserPageMargin, kHXSCREEN_HEIGHT)];
    [[self mainWindow] addSubview:_photoScrollView];
    _photoScrollView.backgroundColor = [UIColor clearColor];
    _photoScrollView.showsVerticalScrollIndicator = NO;
    _photoScrollView.showsHorizontalScrollIndicator = NO;
    _photoScrollView.pagingEnabled = YES;
    _photoScrollView.delegate = self;
    _photoScrollView.contentSize = CGSizeMake(self.photoCount == PhotoCountMultiple ? (kHXSCREEN_WIDTH + kHXPhotoBrowserPageMargin) * _urlArray.count : kHXSCREEN_WIDTH * _urlArray.count, kHXSCREEN_HEIGHT);
    
    [self addGesture];
    [self creatPhotoImageView];
}

- (void)setImageViewArray{
    NSMutableArray *arrayM = [NSMutableArray array];
    for (int i = 0; i < _urlArray.count; i ++) {
        if (i != self.currentIndex ? : 0) {
            HXPhotoImageView *imageView = [[HXPhotoImageView alloc] initWithFrame:CGRectMake(i * self.pageWidth, 0, kHXSCREEN_WIDTH, kHXSCREEN_HEIGHT)];
            [self.photoScrollView addSubview:imageView];
            imageView.imageView.frame = [self getNewRectWithIndex:i];
            [arrayM addObject:imageView];
            imageView.config = self.config;
            imageView.delegate = self;
        } else{
            HXPhotoImageView *currentImageView = [[HXPhotoImageView alloc] initWithFrame:CGRectMake(self.currentIndex ? self.currentIndex * self.pageWidth : 0, 0, kHXSCREEN_WIDTH, kHXSCREEN_HEIGHT)];
            self.currentImageView = currentImageView;
            [arrayM addObject:currentImageView];
            currentImageView.config = self.config;
            currentImageView.delegate = self;
        }
    }
    _imageViewArray = arrayM.copy;
}

- (void)creatPhotoImageView{
    self.photoScrollView.contentOffset = CGPointMake(_currentIndex ? _currentIndex * self.pageWidth : 0, 0);
    
    [self setImageViewArray];
    
    _currentIndex = _currentIndex ? : 0;
    _firstIndex = _currentIndex;
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager diskImageExistsForURL:self.urlArray[_currentIndex] completion:^(BOOL isInCache) {
        [self.photoScrollView addSubview:self.currentImageView];
        if (isInCache) {
            [self photoInCache];
        } else{
            [self photoNotInCache];
        }
    }];
    
    if (_photoViewArray.count > 1) {
        [self setIndexLabel];
    }
}

- (void)setImageViewBackgroundColor{
    [self.imageViewArray enumerateObjectsUsingBlock:^(HXPhotoImageView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.imageView.backgroundColor = [UIColor grayColor];
    }];
}

- (void)photoNotInCache{
    self.firstImageView.imageView.frame = [self getNewRectWithIndex:_firstIndex];
    [self setImageViewBackgroundColor];
    [self.firstImageView beginProcess];
    
    __weak __typeof(self)weakSelf = self;
    [self.firstImageView.imageView sd_setImageWithURL:_urlArray[_firstIndex] placeholderImage:[self getPlaceholderImageWithIndex:_firstIndex] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        [weakSelf updateProgressWithPhotoImage:weakSelf.firstImageView expectedSize:(CGFloat)expectedSize receivedSize:(CGFloat)receivedSize];
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        [weakSelf.firstImageView finishProcess];
        [weakSelf fetchOtherPhotos];
        [weakSelf updateRectWithIndex:weakSelf.firstIndex withImage:image];
    }];
}

- (void)photoInCache{
    __weak __typeof(self)weakSelf = self;
    self.currentImageView.isfinish = YES;
    [self.currentImageView.imageView sd_setImageWithURL:self.urlArray[self.currentIndex] placeholderImage:nil options:SDWebImageRetryFailed completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (weakSelf.currentImageView.imageView.image) {
            weakSelf.currentImageView.imageView.frame = [self getStartRect];
            [weakSelf.currentImageView finishProcess];
            [weakSelf transitionAnimation];
            [weakSelf fetchOtherPhotos];
        } else{
            [weakSelf photoNotInCache];
        }
    }];
}

- (void)fetchOtherPhotos{
    [self setImageViewBackgroundColor];
    
    __weak __typeof(self)weakSelf = self;
    [_imageViewArray enumerateObjectsUsingBlock:^(HXPhotoImageView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx != self.firstIndex ? : 0) {
            obj.imageView.backgroundColor = [UIColor grayColor];
            [obj.imageView sd_setImageWithURL:self.urlArray[idx] placeholderImage:[self getPlaceholderImageWithIndex:idx] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                [obj beginProcess];
                [weakSelf updateProgressWithPhotoImage:obj expectedSize:(CGFloat)expectedSize receivedSize:(CGFloat)receivedSize];
            } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                [obj finishProcess];
                [weakSelf updateRectWithIndex:idx withImage:image];
            }];
        }
    }];
}

- (void)updateProgressWithPhotoImage:(HXPhotoImageView *)photoImage expectedSize:(CGFloat)expectedSize receivedSize:(CGFloat)receivedSize{
    if (photoImage != self.currentImageView) {
        return;
    }
    
    photoImage.expectedSize = (CGFloat)expectedSize;
    photoImage.receivedSize = (CGFloat)receivedSize;
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
    _panStartY = self.currentImageView.frame.origin.y;
    _panEndY = kHXSCREEN_HEIGHT;
}

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
    if (translation.y <= 0 || _isCanPan == NO) {
        return NO;
    }
    return YES;
}

- (void)scrollViewDidScrollWithRecognizer:(UIPanGestureRecognizer *)recognizer isOverHeight:(BOOL)isOverHeight{
    _isOverHeight = isOverHeight;
    [self move:recognizer];
}


- (void)move:(UIPanGestureRecognizer *)recognizer{
    if(_isCanPan == NO) return;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kHXPhotoBrowserRingDismiss object:nil];
    
    CGPoint pt = [recognizer translationInView:self.currentImageView];
    
    self.currentImageView.imageView.frame = CGRectMake(self.currentImageView.imageView.frame.origin.x + pt.x, self.currentImageView.imageView.frame.origin.y + pt.y, self.currentImageView.imageView.frame.size.width, self.currentImageView.imageView.frame.size.height);
    
    _panMoveY += pt.y;
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.currentImageView.scrollView];
    
    if (recognizer.state == UIGestureRecognizerStateChanged){
        _effectView.alpha = 1 - _panMoveY / (_panEndY - _panStartY) * 1.5;
        CGFloat zoomProportion = 1 -  pt.y / kHXSCREEN_HEIGHT * 0.8;
        
        if (pt.y > 0) {
            self.currentImageView.imageView.transform = CGAffineTransformScale(self.currentImageView.imageView.transform, zoomProportion, zoomProportion);
        } else if (pt.y < 0 && self.currentImageView.scrollView.zoomScale < kHXPhotoBrowserZoomMin){
            self.currentImageView.imageView.transform = CGAffineTransformScale(self.currentImageView.imageView.transform, zoomProportion, zoomProportion);
        }
        
    } else if (recognizer.state == UIGestureRecognizerStateEnded){
        CGFloat y = self.currentImageView.imageView.frame.size.height < kHXSCREEN_HEIGHT ?
        kHXSCREEN_HEIGHT / 2 - self.currentImageView.imageView.frame.size.height / 2 + kHXPhotoBrowserDisMissValue :
        kHXPhotoBrowserDisMissValue;
        
        if (self.currentImageView.imageView.frame.origin.y < y) {
            [UIView animateWithDuration:0.2 animations:^{
                self.currentImageView.imageView.frame = [self getNewRectWithIndex:self.currentIndex];
                self.effectView.alpha = 1;
            } completion:^(BOOL finished) {
                if (!self.currentImageView.isfinish) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:kHXPhotoBrowserRingShow object:nil];
                }
            }];
            _panMoveY = 0;
        } else{
            [self dismiss];
        }
    }
}

- (void)zoom:(UITapGestureRecognizer *)recognizer{
    
    CGPoint touchPoint = [recognizer locationInView:self.view];
    
    if (self.currentImageView.scrollView.zoomScale <= kHXPhotoBrowserZoomMin) {
        self.currentImageView.scrollView.maximumZoomScale = kHXPhotoBrowserZoomMid;
        [self.currentImageView.scrollView zoomToRect:CGRectMake(touchPoint.x, touchPoint.y, 1, 1) animated:YES];
        _isCanPan = NO;
    } else {
        [self.currentImageView.scrollView setZoomScale:kHXPhotoBrowserZoomMin animated:YES];
        _isCanPan = YES;
    }
}



- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view{
    _isCanPan = NO;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    if (scale <= kHXPhotoBrowserZoomMin || self.currentImageView.frame.size.height <= kHXSCREEN_HEIGHT) {
        [UIView animateWithDuration:0.3 animations:^{
            [self.currentImageView setCenter:CGPointMake(self.currentImageView.center.x,scrollView.center.y)];
        }];
    }
    
    if (scale <= kHXPhotoBrowserZoomMin) {
        _isCanPan = YES;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger currentNum = scrollView.contentOffset.x / _pageWidth;
    
    if (_currentIndex != currentNum && ((NSInteger)scrollView.contentOffset.x % (NSInteger)_pageWidth == 0)) {
        [self.currentImageView.scrollView setZoomScale:kHXPhotoBrowserZoomMin];
        _isCanPan = YES;
    }
    
    if (_isCanPan) {
        _currentIndex = currentNum;
    }
    [self setIndexTitleWithIndex:currentNum];
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
    
    self.photoCount = urlStrArray.count > 1 ? PhotoCountMultiple : PhotoCountSingle;
    self.pageWidth = self.photoCount ? kHXSCREEN_WIDTH + kHXPhotoBrowserPageMargin : kHXSCREEN_WIDTH;
    
    _urlArray = urlArray.copy;
}


- (void)show{
    [self setPhotoScrollView];
    
    [_parentVC presentViewController:self animated:NO completion:nil];
    
}

- (void)dismiss{
    if (self.currentImageView.scrollView.zoomScale > kHXPhotoBrowserZoomMin) {
        [self.currentImageView.scrollView setZoomScale:kHXPhotoBrowserZoomMin];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kHXPhotoBrowserRingDismiss object:nil];
    
    [UIView animateWithDuration:0.15 animations:^{
        self.currentImageView.imageView.frame = [self getStartRect];
        self.effectView.alpha = 0;
        
    } completion:^(BOOL finished) {
        [self.photoScrollView removeFromSuperview];
        self.photoScrollView = nil;
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}

- (void)setIndexTitleWithIndex:(NSInteger)index{
    _indexLabel.text = [NSString stringWithFormat:@"%ld / %ld",index + 1,_imageViewArray.count];
}

- (void)transitionAnimation{
    [UIView animateWithDuration:0.25 animations:^{
        self.currentImageView.imageView.frame = [self getNewRectWithIndex:self.currentIndex];
    }];
}

- (void)setPhotoViewArray:(NSArray<UIView *> *)photoViewArray{
    _photoViewArray = photoViewArray;
    
    NSMutableArray *arrayM = [NSMutableArray array];
    
    for (UIView *view in photoViewArray) {
        UIImage *image = [UIImage new];
        
        if ([view isKindOfClass:[UIImageView class]]){
            UIImageView *img = (UIImageView *)view;
            image = img.image;
        }
        
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)view;
            image = btn.currentImage ? btn.currentImage : btn.currentBackgroundImage;
        }
        
        if (image) {
            CGSize size = [[HXPhotoHelper shared] uniformScaleWithImage:image withPhotoLevel:HXPhotoLevelWidth float:kHXSCREEN_WIDTH];
            [arrayM addObject:[NSNumber numberWithFloat:size.height]];
        } else{
            [arrayM addObject:[NSNumber numberWithFloat:kHXSCREEN_WIDTH]];
        }
    }
    
    _heightArray = arrayM;
}

- (UIImage *)getPlaceholderImageWithIndex:(NSInteger)index{
    UIImage *image = [UIImage new];
    if ([_photoViewArray[index] isKindOfClass:[UIImageView class]]){
        UIImageView *img = (UIImageView *)_photoViewArray[index];
        image = img.image;
    }
    
    if ([_photoViewArray[index] isKindOfClass:[UIButton class]]) {
        UIButton *btn = (UIButton *)_photoViewArray[index];
        image = btn.currentImage ? btn.currentImage : btn.currentBackgroundImage;
    }
    
    return image;
}

- (CGRect)getStartRect{
    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
    CGRect startRact = [_photoViewArray[_currentIndex] convertRect:_photoViewArray[_currentIndex].bounds toView:window];
    
    return startRact;
}

- (CGRect)getNewRectWithIndex:(NSInteger)index{
    CGFloat width = kHXSCREEN_WIDTH;
    NSNumber *currentHeight = self.heightArray[index];
    CGFloat height = currentHeight.floatValue;
    CGRect newFrame = CGRectMake(0, kHXSCREEN_HEIGHT >= height ? (kHXSCREEN_HEIGHT - height) / 2 : 0, width, height);
    
    
    return newFrame;
}

- (void)updateRectWithIndex:(NSInteger)index withImage:(UIImage *)image{
    NSMutableArray *arrayM = self.heightArray.mutableCopy;
    
    if (image) {
        CGSize size = [[HXPhotoHelper shared] uniformScaleWithImage:image withPhotoLevel:HXPhotoLevelWidth float:kHXSCREEN_WIDTH];
        arrayM[index] = [NSNumber numberWithFloat:size.height];
    } else{
        arrayM[index] = [NSNumber numberWithFloat:kHXSCREEN_WIDTH];
    }
    
    self.heightArray = arrayM.copy;
    HXPhotoImageView *photoImageView = _imageViewArray[index];
    photoImageView.imageView.frame = [self getNewRectWithIndex:index];
}

- (HXPhotoImageView *)currentImageView{
    return self.imageViewArray[self.currentIndex];
}

- (HXPhotoImageView *)firstImageView{
    return self.imageViewArray[self.firstIndex];
}


- (UIWindow *)mainWindow{
    NSArray *windows = [UIApplication sharedApplication].windows;
    for(UIWindow *window in [windows reverseObjectEnumerator]) {
        if ([window isKindOfClass:[UIWindow class]] &&
            CGRectEqualToRect(window.bounds, [UIScreen mainScreen].bounds))
            return window;
    }
    return [UIApplication sharedApplication].keyWindow;
}

- (void)dealloc{
    [_indexLabel removeFromSuperview];
    _indexLabel = nil;
    
}
@end
