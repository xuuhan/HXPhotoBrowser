//
//  HXPhotoImageView.h
//  HXPhotoBrowser
//
//  Created by suin on 2018/8/16.
//  Copyright © 2018年 韩旭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+SDWebImage.h"
@interface HXPhotoImageView : UIImageView

@property (nonatomic, assign) CGFloat receivedSize;
@property (nonatomic, assign) CGFloat expectedSize;

- (void)finishProcess;
@end
