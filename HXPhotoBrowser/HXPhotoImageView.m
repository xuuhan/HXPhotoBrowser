//
//  HXPhotoImageView.m
//  HXPhotoBrowser
//
//  Created by suin on 2018/8/16.
//  Copyright © 2018年 韩旭. All rights reserved.
//

#import "HXPhotoImageView.h"
#import "HXPhotoBrowserMacro.h"
#import "HXPhotoHelper.h"

static const CGFloat sAngle = - M_PI_2;
static const CGFloat eAngle = M_PI * 2;

@interface HXPhotoImageView()<UIScrollViewDelegate,UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIVisualEffectView *effectView;
@property (nonatomic, strong) UIView *processBar;
@property (nonatomic, strong) UIImage *blurImage;
@property (nonatomic, strong) CAShapeLayer *circleLayer;
@property (nonatomic, assign) CGFloat startY;
@property (nonatomic, assign) CGFloat lastY;
@property (nonatomic, assign) BOOL isPanDismiss;
@property (nonatomic, assign) BOOL isOverHeight;
@property (nonatomic, assign) BOOL isDraging;
@property (nonatomic, assign) BOOL isImageNotication;
@end

@implementation HXPhotoImageView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self setScrollView];
        
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (void)setConfig:(HXPhotoConfig *)config{
    _config = config;
    
    if (config.photoLoadType == HXPhotoLoadTypeMask) {
        [self setEffectView];
    } else if (config.photoLoadType == HXPhotoLoadTypeProgressive){
        [_imageView addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionNew context:nil];
        self.isImageNotication = YES;
    }
    
    if (config.photoProgressType == HXPhotoProgressTypeBar) {
        [self setProcessBar];
    } else if(config.photoProgressType == HXPhotoProgressTypeRing){
        [self setProcessRing];
        
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ringShow) name:kHXPhotoBrowserRingShow object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ringDismiss) name:kHXPhotoBrowserRingDismiss object:nil];
    }
}

- (void)setMaskHidden:(BOOL)hidden{
    if (self.effectView) {
        self.effectView.hidden = hidden;
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
    return _imageView;
}

- (CGPoint)centerOfScrollViewContent:(UIScrollView *)scrollView {
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    CGPoint center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                 scrollView.contentSize.height * 0.5 + offsetY);
    return center;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    _scrollView.maximumZoomScale = kHXPhotoBrowserZoomMax;
    _imageView.center = [self centerOfScrollViewContent:scrollView];
}

- (void)setScrollView{
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    [self addSubview:_scrollView];
    _scrollView.delegate = self;
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.minimumZoomScale = kHXPhotoBrowserZoomMin;
    _scrollView.maximumZoomScale = kHXPhotoBrowserZoomMax;
    _scrollView.zoomScale = kHXPhotoBrowserZoomMin;
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    if (@available(iOS 11.0, *)) {
        _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    CGFloat width = kHXSCREEN_WIDTH;
    CGFloat height = width;
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (kHXSCREEN_HEIGHT - height) / 2, width, height)];
    [_scrollView addSubview:_imageView];
    [_imageView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.layer.masksToBounds = YES;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (_startY == 0 && scrollView.contentOffset.y < 0) {
        [self overHeightScrollView];
        _isDraging = YES;
        
    } else if (_isDraging){
        [self overHeightScrollView];
        
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView.panGestureRecognizer.state == UIGestureRecognizerStateEnded && self.isPanDismiss) {
        [self overHeightScrollView];
    }
    
    _isDraging = NO;
    _isPanDismiss = NO;
}

- (void)overHeightScrollView{
    if ([self.delegate respondsToSelector:@selector(scrollViewDidScrollWithRecognizer:isOverHeight:)]) {
        [self.delegate scrollViewDidScrollWithRecognizer:_scrollView.panGestureRecognizer isOverHeight:_isOverHeight];
        self.isPanDismiss = YES;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    _startY = scrollView.contentOffset.y;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"frame"]) {
        CGRect rect = [[change objectForKey:@"new"] CGRectValue];
        if (!_isDraging) {
            if (rect.size.height >= kHXSCREEN_HEIGHT && rect.size.height < kHXSCREEN_HEIGHT + 1) {
                _scrollView.contentSize = CGSizeMake(0, kHXSCREEN_HEIGHT);
            } else{
                _scrollView.contentSize = rect.size;
            }
        }
        if (rect.size.height > kHXSCREEN_HEIGHT) {
            self.isOverHeight = YES;
        }
    }
    
    if ([keyPath isEqualToString:@"image"]) {
        if (!self.blurImage && [[change objectForKey:@"new"] isKindOfClass:[UIImage class]]) {
            self.blurImage = [change objectForKey:@"new"];
            if (!self.isfinish) {
                self.imageView.image = [[HXPhotoHelper shared] blurryImage:self.blurImage withBlurLevel: 1];
            }
        }
    }
}


- (void)setEffectView{
    UIBlurEffect *blurEffect =[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    _effectView =[[UIVisualEffectView alloc]initWithEffect:blurEffect];
    _effectView.frame = CGRectMake(0, 0, self.imageView.frame.size.width, self.imageView.frame.size.height);
    _effectView.hidden = YES;
    [self.imageView addSubview:_effectView];
    _effectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
}

- (void)setProcessBar{
    _processBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, kHXPhotoBrowserProcessHeight)];
    [_imageView addSubview:_processBar];
    _processBar.backgroundColor = [UIColor whiteColor];
}

- (void)setProcessRing{
    
    CGPoint point = CGPointMake(kHXSCREEN_WIDTH / 2, kHXSCREEN_HEIGHT / 2);
    CGFloat radius = 20;
    CGFloat lineWidth = 4;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:point radius:radius startAngle:sAngle endAngle:eAngle clockwise:YES];
    
    _circleLayer = [CAShapeLayer layer];
    _circleLayer.strokeColor = [UIColor colorWithRed:192.0/255.0f green:192.0/255.0f blue:192.0/255.0f alpha:0.8].CGColor;
    _circleLayer.fillColor = [UIColor clearColor].CGColor;
    _circleLayer.path = path.CGPath;
    _circleLayer.lineWidth = lineWidth;
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(radius, radius) radius:radius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.contentsScale = [[UIScreen mainScreen] scale];
    shapeLayer.strokeStart = 0;
    shapeLayer.strokeEnd = 0.25;
    shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.frame = CGRectMake(kHXSCREEN_WIDTH / 2 - radius, kHXSCREEN_HEIGHT / 2 - radius, radius * 2, radius * 2);
    shapeLayer.path = bezierPath.CGPath;
    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.lineJoin = kCALineJoinBevel;
    shapeLayer.lineWidth = lineWidth;
    [_circleLayer addSublayer:shapeLayer];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    animation.fromValue = 0;
    animation.toValue = @(2 * M_PI);
    animation.removedOnCompletion = NO;
    animation.repeatCount = NSIntegerMax;
    animation.duration = 1;
    [shapeLayer addAnimation:animation forKey:@"animate"];
    
}

- (void)maskDismiss{
    [UIView animateWithDuration:0.2 animations:^{
        self.effectView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.effectView removeFromSuperview];
        self.effectView = nil;
    }];
}

- (void)barDisimiss{
    [UIView animateWithDuration:0.2 animations:^{
        self.processBar.alpha = 0;
    } completion:^(BOOL finished) {
        [self.processBar removeFromSuperview];
        self.processBar = nil;
    }];
}

- (void)ringDismiss{
    [_circleLayer removeFromSuperlayer];
}

- (void)ringShow{
    [self.layer addSublayer:_circleLayer];
}

- (void)beginProcess{
    if (_config.photoLoadType == HXPhotoLoadTypeMask) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setMaskHidden:NO];
        });
    }
    
    if (_config.photoProgressType == HXPhotoProgressTypeRing) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.layer addSublayer:self.circleLayer];
        });
    }
}

- (void)finishProcess{
    self.isfinish = YES;
    
    if (_config.photoLoadType == HXPhotoLoadTypeMask) {
        [self maskDismiss];
    }
    
    if (_config.photoProgressType == HXPhotoProgressTypeRing){
        [self ringDismiss];
    }
    
    if (_config.photoProgressType == HXPhotoProgressTypeBar) {
        [self barDisimiss];
    }
}

- (void)setReceivedSize:(CGFloat)receivedSize{
    _receivedSize = receivedSize;
    
    // 拿到进度比例范围从0.8到1
    CGFloat scale = 0.8 + (1 - 0.8) * (receivedSize / _expectedSize);
    // 初始化进度
    if (isnan(scale)) {
        scale = 0.8; // 当计算结果为NaN时，默认为0.8
    }
    // 赋值进度
    CGRect frame = CGRectMake(0, 0, scale * kHXSCREEN_WIDTH, kHXPhotoBrowserProcessHeight);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.1 animations:^{
            self.processBar.frame = frame;
            if (self.blurImage && self.config.photoLoadType == HXPhotoLoadTypeProgressive) {
                self.imageView.image = [[HXPhotoHelper shared] blurryImage:self.blurImage withBlurLevel: 1 - scale];
            }
        }];
    });
}

- (void)dealloc{
    [_imageView removeObserver:self forKeyPath:@"frame"];
    if (self.isImageNotication) {
        [_imageView removeObserver:self forKeyPath:@"image"];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
