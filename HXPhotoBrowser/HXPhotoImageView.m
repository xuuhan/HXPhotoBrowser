//
//  HXPhotoImageView.m
//  HXPhotoBrowser
//
//  Created by suin on 2018/8/16.
//  Copyright © 2018年 韩旭. All rights reserved.
//

#import "HXPhotoImageView.h"
#import "HXPhotoBrowserMacro.h"

@interface HXPhotoImageView()
@property (nonatomic, strong) UIVisualEffectView *effectView;
@property (nonatomic, strong) UIView *processView;
@end

@implementation HXPhotoImageView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setEffectView];
        [self setProcessView];
        self.layer.masksToBounds = YES;
    }
    return self;
}


- (void)setEffectView{
    UIBlurEffect *blurEffect =[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    _effectView =[[UIVisualEffectView alloc]initWithEffect:blurEffect];
    _effectView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self addSubview:_effectView];
    _effectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
}

- (void)setProcessView{
    _processView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, kHXPhotoBrowserProcessHeight)];
    [self addSubview:_processView];
    _processView.backgroundColor = [UIColor whiteColor];
}

- (void)finishProcess{
    
    
    [UIView animateWithDuration:0.2 animations:^{
        self.effectView.alpha = 0;
        self.processView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.effectView removeFromSuperview];
        self.effectView = nil;
        [self.processView removeFromSuperview];
        self.processView = nil;
    }];
}

- (void)setReceivedSize:(CGFloat)receivedSize{
    _receivedSize = receivedSize;
    
    NSLog(@"%f----%f----%f----%f",receivedSize / _expectedSize * SCREEN_WIDTH,receivedSize,_expectedSize,SCREEN_WIDTH);
    CGRect frame = CGRectMake(0, 0, receivedSize / _expectedSize * SCREEN_WIDTH, kHXPhotoBrowserProcessHeight);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.2 animations:^{
            self.processView.frame = frame;
        }];
    });
    
}


@end
