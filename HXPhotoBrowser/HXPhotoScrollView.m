//
//  HXPhotoScrollView.m
//  HXPhotoBrowser
//
//  Created by suin on 2018/8/14.
//  Copyright © 2018年 韩旭. All rights reserved.
//

#import "HXPhotoScrollView.h"

@interface HXPhotoScrollView()

@end

@implementation HXPhotoScrollView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.minimumZoomScale = 1.0f;
        self.maximumZoomScale = 2.0f;
        self.zoomScale = 1.0f;
    }
    return self;
}



@end
