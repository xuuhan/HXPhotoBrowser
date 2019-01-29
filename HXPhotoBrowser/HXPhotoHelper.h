//
//  HXPhotoHelper.h
//  HXPhotoBrowser
//
//  Created by suin on 2019/1/29.
//  Copyright © 2019年 韩旭. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, HXPhotoLevel) {
    HXPhotoLevelWidth = 0,
    HXPhotoLevelHeight
};

@interface HXPhotoHelper : NSObject



+ (CGSize)uniformScaleWithImage:(UIImage *)sourceImage withPhotoLevel:(HXPhotoLevel)photoLevel float:(CGFloat)levelFloat;
@end

NS_ASSUME_NONNULL_END
