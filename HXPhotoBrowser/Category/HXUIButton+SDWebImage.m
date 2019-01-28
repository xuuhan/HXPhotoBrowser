//
//  HXUIButton+SDWebImage.m
//  HXPhotoBrowser
//
//  Created by suin on 2018/8/14.
//  Copyright © 2018年 韩旭. All rights reserved.
//

#import "HXUIButton+SDWebImage.h"
#import <objc/runtime.h>

const static NSString *FadeButtonTypeKey = @"FadeButtonTypeKey";

@implementation UIButton (SDWebImage)

- (void)sd_setFadeImageWithURL:(nullable NSURL *)url
                      forState:(UIControlState)state{
    [self sd_setFadeImageWithURL:url forState:state placeholderImage:nil options:0 completed:nil];
}

- (void)sd_setFadeImageWithURL:(nullable NSURL *)url
                      forState:(UIControlState)state
              placeholderImage:(nullable UIImage *)placeholder{
    [self sd_setFadeImageWithURL:url forState:state placeholderImage:placeholder options:0 completed:nil];
}

- (void)sd_setFadeImageWithURL:(nullable NSURL *)url
                      forState:(UIControlState)state
              placeholderImage:(nullable UIImage *)placeholder
                       options:(SDWebImageOptions)options{
    [self sd_setFadeImageWithURL:url forState:state placeholderImage:placeholder options:options completed:nil];
}

- (void)sd_setFadeImageWithURL:(nullable NSURL *)url
                      forState:(UIControlState)state
                     completed:(nullable SDExternalCompletionBlock)completedBlock{
    [self sd_setFadeImageWithURL:url forState:state placeholderImage:nil options:0 completed:completedBlock];
}

- (void)sd_setFadeImageWithURL:(nullable NSURL *)url
                      forState:(UIControlState)state
              placeholderImage:(nullable UIImage *)placeholder
                     completed:(nullable SDExternalCompletionBlock)completedBlock{
    [self sd_setFadeImageWithURL:url forState:state placeholderImage:placeholder options:0 completed:completedBlock];
}

- (void)sd_setFadeImageWithURL:(nullable NSURL *)url
                      forState:(UIControlState)state
              placeholderImage:(nullable UIImage *)placeholder
                       options:(SDWebImageOptions)options
                     completed:(nullable SDExternalCompletionBlock)completedBlock{
    
    [self sd_setImageWithURL:url forState:state placeholderImage:placeholder options:options completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
        [self fadeAnimationWith:image error:error cacheType:cacheType imageURL:imageURL completed:completedBlock];
    }];
}


- (void)sd_setFadeBackgroundImageWithURL:(nullable NSURL *)url
                                forState:(UIControlState)state{
    [self sd_setFadeBackgroundImageWithURL:url forState:state placeholderImage:nil options:0 completed:nil];
    
}

- (void)sd_setFadeBackgroundImageWithURL:(nullable NSURL *)url
                                forState:(UIControlState)state
                        placeholderImage:(nullable UIImage *)placeholder{
    [self sd_setFadeBackgroundImageWithURL:url forState:state placeholderImage:placeholder options:0 completed:nil];
}

- (void)sd_setFadeBackgroundImageWithURL:(nullable NSURL *)url
                                forState:(UIControlState)state
                        placeholderImage:(nullable UIImage *)placeholder
                                 options:(SDWebImageOptions)options{
    [self sd_setFadeBackgroundImageWithURL:url forState:state placeholderImage:placeholder options:options completed:nil];
}

- (void)sd_setFadeBackgroundImageWithURL:(nullable NSURL *)url
                                forState:(UIControlState)state
                               completed:(nullable SDExternalCompletionBlock)completedBlock{
    [self sd_setFadeBackgroundImageWithURL:url forState:state placeholderImage:nil options:0 completed:completedBlock];
}

- (void)sd_setFadeBackgroundImageWithURL:(nullable NSURL *)url
                                forState:(UIControlState)state
                        placeholderImage:(nullable UIImage *)placeholder
                               completed:(nullable SDExternalCompletionBlock)completedBlock{
    [self sd_setFadeBackgroundImageWithURL:url forState:state placeholderImage:placeholder options:0 completed:completedBlock];
}

- (void)sd_setFadeBackgroundImageWithURL:(nullable NSURL *)url
                                forState:(UIControlState)state
                        placeholderImage:(nullable UIImage *)placeholder
                                 options:(SDWebImageOptions)options
                               completed:(nullable SDExternalCompletionBlock)completedBlock{
    
    __weak __typeof(self)weakSelf = self;
    [self sd_setBackgroundImageWithURL:url forState:state placeholderImage:placeholder options:options completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        [strongSelf fadeAnimationWith:image error:error cacheType:cacheType imageURL:imageURL completed:completedBlock];
    }];
}

- (void)fadeAnimationWith:(UIImage * _Nullable)image error:(NSError * _Nullable)error cacheType:(SDImageCacheType)cacheType imageURL:(NSURL * _Nullable)imageURL completed:(nullable SDExternalCompletionBlock)completedBlock{
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
}

- (FadeType)FadeType{
    NSNumber *numVaue = objc_getAssociatedObject(self, &FadeButtonTypeKey);
    return [numVaue integerValue];
}

- (void)setFadeType:(FadeType)FadeType{
    objc_setAssociatedObject(self, &FadeButtonTypeKey, @(FadeType), OBJC_ASSOCIATION_ASSIGN);
}

@end
