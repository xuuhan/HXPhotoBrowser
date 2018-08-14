//
//  UIImage+SDWebImage.m
//  HXPhotoBrowser
//
//  Created by suin on 2018/8/14.
//  Copyright © 2018年 韩旭. All rights reserved.
//

#import "UIImageView+SDWebImage.h"

@implementation UIImageView (SDWebImage)

- (void)sd_setFadeImageWithURL:(nullable NSURL *)url{
    [self sd_setFadeImageWithURL:url placeholderImage:nil options:0 progress:nil completed:nil];
}

- (void)sd_setFadeImageWithURL:(nullable NSURL *)url
              placeholderImage:(nullable UIImage *)placeholder{
    [self sd_setFadeImageWithURL:url placeholderImage:placeholder options:0 progress:nil completed:nil];
}

- (void)sd_setFadeImageWithURL:(nullable NSURL *)url
              placeholderImage:(nullable UIImage *)placeholder
                       options:(SDWebImageOptions)options{
    [self sd_setFadeImageWithURL:url placeholderImage:placeholder options:options progress:nil completed:nil];
}   

- (void)sd_setFadeImageWithURL:(nullable NSURL *)url
                     completed:(nullable SDExternalCompletionBlock)completedBlock{
    [self sd_setFadeImageWithURL:url placeholderImage:nil options:0 progress:nil completed:completedBlock];
}

- (void)sd_setFadeImageWithURL:(nullable NSURL *)url
              placeholderImage:(nullable UIImage *)placeholder
                     completed:(nullable SDExternalCompletionBlock)completedBlock{
    [self sd_setFadeImageWithURL:url placeholderImage:placeholder options:0 progress:nil completed:completedBlock];
}

- (void)sd_setFadeImageWithURL:(nullable NSURL *)url
              placeholderImage:(nullable UIImage *)placeholder
                       options:(SDWebImageOptions)options
                     completed:(nullable SDExternalCompletionBlock)completedBlock{
    [self sd_setFadeImageWithURL:url placeholderImage:placeholder options:options progress:nil completed:completedBlock];
}

- (void)sd_setFadeImageWithURL:(nullable NSURL *)url
              placeholderImage:(nullable UIImage *)placeholder
                       options:(SDWebImageOptions)options
                      progress:(nullable SDWebImageDownloaderProgressBlock)progressBlock
                     completed:(nullable SDExternalCompletionBlock)completedBlock{
    
    [self sd_setImageWithURL:url placeholderImage:placeholder options:options progress:progressBlock completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
        __weak __typeof(self)weakSelf = self;
        
        if (image && cacheType == SDImageCacheTypeNone) {
            CATransition *animation = [CATransition animation];
            [animation setType:kCATransitionFade];
            [animation setDuration:0.8f];
            animation.removedOnCompletion = YES;
            [weakSelf.layer addAnimation:animation forKey:@"fade"];
        }
        
        if (completedBlock) {
            completedBlock(image, error, cacheType, imageURL);
        }
    }];
}

@end
