//
//  HXPhotoBrowserViewController.h
//  HXPhotoBrowser
//
//  Created by suin on 2018/8/15.
//  Copyright © 2018年 韩旭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXPhotoBrowserViewController : UIViewController

@property (nonatomic, strong) UIViewController *parentVC;
@property (nonatomic, strong) NSArray <NSString *>*urlStrArray;
///多图的话按顺序传入
@property (nonatomic, strong) NSArray <UIView *>*selectedViewArray;
///默认为第一张
@property (nonatomic, assign) NSInteger currentIndex;
- (void)show;
@end
