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
    ///第一次请求图片时做动画（没有缓存时）
    FadeTypeFirstAfterFetch,
    ///每次启动后只做一次动画（磁盘缓存时）
    FadeTypeOnceAfterAppLaunch,
    ///每次都会做动画
    FadeTypeEveryTime,
};

@interface UIImageView (SDWebImage)

/**
 不设置则为FadeTypeFirstAfterFetch
 */
@property (nonatomic, assign) FadeType FadeType;

/**
 与UIImageView+WebCache使用方法相同
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
                  progress:(nullable SDWebImageDownloaderProgressBlock)progressBlock
                 completed:(nullable SDExternalCompletionBlock)completedBlock;

@end
