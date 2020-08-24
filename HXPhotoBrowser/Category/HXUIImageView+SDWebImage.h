//
//  HXUIImageView+SDWebImage.h
//  HXPhotoBrowser
//
//  Created by suin on 2018/8/14.
//  Copyright © 2018年 韩旭. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>

typedef NS_ENUM(NSInteger,FadeType){
    ///只在第一次请求图片时做动画（没有缓存时）
    ///only animation after first fetch(no cache)
    FadeTypeFirstAfterFetch,
    ///每次启动后只做一次动画（磁盘缓存时）
    ///animate once when App launch(disk cache)
    FadeTypeOnceAfterAppLaunch,
    ///animate everyTime
    FadeTypeEveryTime,
};

@interface UIImageView (SDWebImage)

/**
 Default FadeTypeFirstAfterFetch
 */
@property (nonatomic, assign) FadeType FadeType;

/**
 The same as UIImageView+WebCache
 */
- (void)sd_setFadeImageWithURL:(nullable NSURL *)url;

- (void)sd_setFadeImageWithURL:(nullable NSURL *)url
          placeholderImage:(nullable UIImage *)placeholder;

- (void)sd_setFadeImageWithURL:(nullable NSURL *)url
          placeholderImage:(nullable UIImage *)placeholder
                   options:(SDWebImageOptions)options;

- (void)sd_setFadeImageWithURL:(nullable NSURL *)url
                 completed:(nullable SDExternalCompletionBlock)completedBlock;

- (void)sd_setFadeImageWithURL:(nullable NSURL *)url
          placeholderImage:(nullable UIImage *)placeholder
                 completed:(nullable SDExternalCompletionBlock)completedBlock;

- (void)sd_setFadeImageWithURL:(nullable NSURL *)url
          placeholderImage:(nullable UIImage *)placeholder
                   options:(SDWebImageOptions)options
                 completed:(nullable SDExternalCompletionBlock)completedBlock;

- (void)sd_setFadeImageWithURL:(nullable NSURL *)url
          placeholderImage:(nullable UIImage *)placeholder
                   options:(SDWebImageOptions)options
                  progress:(nullable SDImageLoaderProgressBlock)progressBlock
                 completed:(nullable SDExternalCompletionBlock)completedBlock;

@end
