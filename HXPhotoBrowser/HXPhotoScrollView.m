//
//  HXPhotoScrollView.m
//  HXPhotoBrowser
//
//  Created by suin on 2018/8/14.
//  Copyright © 2018年 韩旭. All rights reserved.
//

#import "HXPhotoScrollView.h"
#import "HXPhotoBrowserMacro.h"

@interface HXPhotoScrollView()

@end

@implementation HXPhotoScrollView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.minimumZoomScale = kHXPhotoBrowserZoomMin;
        self.maximumZoomScale = kHXPhotoBrowserZoomMax;
        self.zoomScale = kHXPhotoBrowserZoomMin;
        self.pagingEnabled = YES;
    }
    return self;
}



@end
