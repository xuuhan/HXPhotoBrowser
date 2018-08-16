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
@property (nonatomic, strong) UIView *selectedView;
@property (nonatomic, strong) NSArray <NSString *>*urlStrArray;

- (void)show;
@end
