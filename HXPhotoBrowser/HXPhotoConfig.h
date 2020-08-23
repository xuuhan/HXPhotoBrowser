//
//  HXPhotoConfig.h
//  HXPhotoBrowser
//
//  Created by suin on 2019/2/12.
//  Copyright © 2019 韩旭. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, HXPhotoLoadType) {
    HXPhotoLoadTypeNormal = 0,
    HXPhotoLoadTypeMask,
    HXPhotoLoadTypeProgressive
};

typedef NS_ENUM(NSUInteger, HXPhotoProgressType) {
    HXPhotoProgressTypeNormal = 0,
    HXPhotoProgressTypeRing,
    HXPhotoProgressTypeBar
};

@interface HXPhotoConfig : NSObject

@property (nonatomic,assign) HXPhotoLoadType photoLoadType;
@property (nonatomic,assign) HXPhotoProgressType photoProgressType;

@end

NS_ASSUME_NONNULL_END
