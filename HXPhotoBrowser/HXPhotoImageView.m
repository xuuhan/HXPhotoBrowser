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

@interface HXPhotoImageView()<UIScrollViewDelegate>
@property (nonatomic, strong) UIVisualEffectView *effectView;
@property (nonatomic, strong) UIView *processBar;
@property (nonatomic, strong) UIImage *blurImage;
@property (nonatomic, strong) CAShapeLayer *circleLayer;
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
    _scrollView.bounces = NO;
    _scrollView.minimumZoomScale = kHXPhotoBrowserZoomMin;
    _scrollView.maximumZoomScale = kHXPhotoBrowserZoomMax;
    _scrollView.zoomScale = kHXPhotoBrowserZoomMin;
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    
    CGFloat width = kHXSCREEN_WIDTH;
    CGFloat height = width;
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (kHXSCREEN_HEIGHT - height) / 2, width, height)];
    [_scrollView addSubview:_imageView];
    [_imageView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"frame"]) {
        CGRect rect = [[change objectForKey:@"new"] CGRectValue];
        _scrollView.contentSize = rect.size;
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
    [self.layer addSublayer:_circleLayer];
    
    
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(radius, radius) radius:radius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.contentsScale = [[UIScreen mainScreen] scale];
    shapeLayer.strokeStart = 0;
    shapeLayer.strokeEnd = 0.25;
    shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.frame = CGRectMake(0, 0, 40, 40);
    shapeLayer.path = bezierPath.CGPath;
    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.lineJoin = kCALineJoinBevel;
    [self.layer addSublayer:shapeLayer];
    

    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    animation.fromValue = 0;
    animation.toValue = @(2 * M_PI);
    animation.removedOnCompletion = NO;
    animation.repeatCount = NSIntegerMax;
    animation.duration = 1.5;
    [shapeLayer addAnimation:animation forKey:@"animate"];
}

- (void)ringDismiss{
    [_circleLayer removeFromSuperlayer];
}

- (void)ringShow{
    [self.layer addSublayer:_circleLayer];
}

- (void)finishProcess{
    
    [UIView animateWithDuration:0.2 animations:^{
        self.effectView.alpha = 0;
        self.processBar.alpha = 0;
    } completion:^(BOOL finished) {
        [self.effectView removeFromSuperview];
        self.effectView = nil;
        [self.processBar removeFromSuperview];
        self.processBar = nil;
    }];
}

- (void)setReceivedSize:(CGFloat)receivedSize{
    _receivedSize = receivedSize;
    
    CGFloat scale = receivedSize / _expectedSize;
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
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
