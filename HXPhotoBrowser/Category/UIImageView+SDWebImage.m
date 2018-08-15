//
//  UIImage+SDWebImage.m
//  HXPhotoBrowser
//
//  Created by suin on 2018/8/14.
//  Copyright © 2018年 韩旭. All rights reserved.
//

#import "UIImageView+SDWebImage.h"
#import <objc/runtime.h>


const static NSString *FadeImgTypeKey = @"FadeImgTypeKey";

@implementation UIImageView (SDWebImage)

- (FadeType)FadeType{
        NSNumber *numVaue = objc_getAssociatedObject(self, &FadeImgTypeKey);
        return [numVaue integerValue];
}

- (void)setFadeType:(FadeType)FadeType{
    objc_setAssociatedObject(self, &FadeImgTypeKey, @(FadeType), OBJC_ASSOCIATION_ASSIGN);
}

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
        
        BOOL isFirst = image && cacheType == SDImageCacheTypeNone;
        BOOL isOnce = image && cacheType == SDImageCacheTypeDisk;
        BOOL isEvery = image && (cacheType == SDImageCacheTypeDisk || cacheType == SDImageCacheTypeMemory);
        BOOL result = false;
        
        if (isFirst) self.FadeType = 0;
        
        if (self.FadeType == FadeTypeOnceAfterAppLaunch) {
            result = isOnce;
        } else if (self.FadeType == FadeTypeEveryTime){
            result = isEvery;
        } else{
            result = isFirst;
        }
        
        if (result) {
            self.alpha = 0.5;
            [UIView animateWithDuration:0.5 animations:^{
                self.alpha = 1;
            }];
        }
        
        if (completedBlock) {
            completedBlock(image, error, cacheType, imageURL);
        }
    }];
}


@end
