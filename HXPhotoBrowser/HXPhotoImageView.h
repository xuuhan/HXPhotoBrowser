//
//  HXPhotoImageView.h
//  HXPhotoBrowser
//
//  Created by suin on 2018/8/16.
//  Copyright © 2018年 韩旭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+SDWebImage.h"
@interface HXPhotoImageView : UIView

@property (nonatomic, assign) CGFloat receivedSize;
@property (nonatomic, assign) CGFloat expectedSize;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIScrollView *scrollView;

- (void)finishProcess;

@end
