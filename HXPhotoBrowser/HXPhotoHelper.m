//
//  HXPhotoHelper.m
//  HXPhotoBrowser
//
//  Created by suin on 2019/1/29.
//  Copyright © 2019年 韩旭. All rights reserved.
//

#import "HXPhotoHelper.h"

@implementation HXPhotoHelper

+ (CGSize)uniformScaleWithImage:(UIImage *)sourceImage withPhotoLevel:(HXPhotoLevel)photoLevel float:(CGFloat)levelFloat{
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    CGSize size = CGSizeZero;
    if (photoLevel == HXPhotoLevelWidth) {
        CGFloat targetWidth = levelFloat;
        CGFloat targetHeight = height / (width / targetWidth);
        size = CGSizeMake(targetWidth, targetHeight);
    } else{
        CGFloat targetHeight = levelFloat;
        CGFloat targetWidth = width / (height / targetHeight);
        size = CGSizeMake(targetWidth, targetHeight);
    }
    
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = size.width;
    CGFloat scaledHeight = size.height;
    
    if(CGSizeEqualToSize(imageSize, size) == NO){
        
        CGFloat widthFactor = size.width / width;
        CGFloat heightFactor = size.height / height;
        
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
    }
    
    CGSize imgSize = CGSizeZero;
    imgSize.width = scaledWidth;
    imgSize.height = scaledHeight;
    
    return imgSize;
}
@end
