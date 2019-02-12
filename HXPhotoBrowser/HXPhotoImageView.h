//
//  HXPhotoImageView.h
//  HXPhotoBrowser
//
//  Created by suin on 2018/8/16.
//  Copyright © 2018年 韩旭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXUIImageView+SDWebImage.h"
@interface HXPhotoImageView : UIView

@property (nonatomic, assign) CGFloat receivedSize;
@property (nonatomic, assign) CGFloat expectedSize;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) BOOL isfinish;

- (void)finishProcess;
- (void)setMaskHidden:(BOOL)hidden;
@end
