//
//  HXPhotoImageView.m
//  HXPhotoBrowser
//
//  Created by suin on 2018/8/16.
//  Copyright © 2018年 韩旭. All rights reserved.
//

#import "HXPhotoImageView.h"
#import "HXShadeView.h"

@interface HXPhotoImageView()
@property (nonatomic, strong) HXShadeView *shade;
@end

@implementation HXPhotoImageView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setShade];
    }
    return self;
}

- (void)setShade{
    _shade = [[HXShadeView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self addSubview:_shade];
    _shade.backgroundColor = [UIColor blackColor];
    _shade.alpha = 0.5;
}

@end
