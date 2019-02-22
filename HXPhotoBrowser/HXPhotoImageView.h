//
//  HXPhotoImageView.h
//  HXPhotoBrowser
//
//  Created by suin on 2018/8/16.
//  Copyright © 2018年 韩旭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXPhotoConfig.h"
#import "HXUIImageView+SDWebImage.h"

@class HXPhotoImageView;

@protocol HXPhotoImageViewDelegate <NSObject>
- (void)scrollViewDidScrollWithRecognizer:(UIPanGestureRecognizer *)recognizer isOverHeight:(BOOL)isOverHeight;

@end

@interface HXPhotoImageView : UIView

@property (nonatomic, assign) CGFloat receivedSize;
@property (nonatomic, assign) CGFloat expectedSize;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) HXPhotoConfig *config;
@property (nonatomic, assign) BOOL isfinish;
@property (nonatomic, weak) id <HXPhotoImageViewDelegate>delegate;

- (void)beginProcess;
- (void)finishProcess;

@end
