//
//  HXPhotoBrowserViewController.h
//  HXPhotoBrowser
//
//  Created by suin on 2018/8/15.
//  Copyright © 2018年 韩旭. All rights reserved.
//  

#import <UIKit/UIKit.h>
#import "HXPhotoConfig.h"
#import "HXPhotoHelper.h"

@interface HXPhotoBrowserViewController : UIViewController

///Parent ViewController
@property (nonatomic, strong) UIViewController *parentVC;
///Image URL (NSString)
@property (nonatomic, strong) NSArray <NSString *>*urlStrArray;
///UIButton or UIImageView
@property (nonatomic, strong) NSArray <UIView *>*photoViewArray;
///array of UIImage, when utlStrArray was nil.
@property (nonatomic, strong) NSArray <UIImage *>*photoImageArray;
///Default is 0
@property (nonatomic, assign) NSInteger currentIndex;
///Defalut is HXPhotoLoadTypeNormal with HXPhotoProgressTypeNormal
@property (nonatomic, strong) HXPhotoConfig *config;


///Go
- (void)show;

@end
