//
//  HXPhotoHelper.m
//  HXPhotoBrowser
//
//  Created by suin on 2019/1/29.
//  Copyright © 2019年 韩旭. All rights reserved.
//

#import "HXPhotoHelper.h"
#import <Accelerate/Accelerate.h>

@implementation HXPhotoHelper

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    static HXPhotoHelper *photoHelper = nil;
    dispatch_once(&onceToken, ^{
        photoHelper = [HXPhotoHelper new];
    });
    
    return photoHelper;
}

- (CGSize)uniformScaleWithImage:(UIImage *)sourceImage withPhotoLevel:(HXPhotoLevel)photoLevel float:(CGFloat)levelFloat{
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

- (UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur {
    if (image == nil) {
        return nil;
    }

    if (blur < 0.f || blur > 1.f) {
        blur = 0.0f;
    }

    blur = 0.25 * blur;
    int boxSize = (int)(blur * 100);
    boxSize = boxSize - (boxSize % 2) + 1;

    CGImageRef img = image.CGImage;

    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;

    void *pixelBuffer;

    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);

    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    inBuffer.data = (void *)CFDataGetBytePtr(inBitmapData);

    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));

    if (pixelBuffer == NULL) {
        NSLog(@"No pixelbuffer");
    }

    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);

    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);

    if (error) {
        NSLog(@"error from convolution %ld", error);
    }

    CGColorSpaceRef colorSpace = CGImageGetColorSpace(img);
    CGContextRef ctx = CGBitmapContextCreate(outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             CGImageGetBitmapInfo(img));

    CGImageRef imageRef = CGBitmapContextCreateImage(ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];

    // Clean up
    CGContextRelease(ctx);
    free(pixelBuffer);
    CFRelease(inBitmapData);
    CGImageRelease(imageRef);

    return returnImage;
}

@end
