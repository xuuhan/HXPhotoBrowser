//
//  HXShadeView.m
//  HXPhotoBrowser
//
//  Created by suin on 2018/8/21.
//  Copyright © 2018年 韩旭. All rights reserved.
//

#import "HXShadeView.h"
#import "HXPhotoBrowserMacro.h"

@interface HXShadeView()
@property (nonatomic, strong) UIVisualEffectView *effectView;
@end

@implementation HXShadeView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self setEffectView];
    }
    return self;
}

- (void)setEffectView{
    UIBlurEffect *blurEffect =[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    _effectView =[[UIVisualEffectView alloc]initWithEffect:blurEffect];
    _effectView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    _effectView.alpha = 1;
    [self addSubview:_effectView];
}

@end
