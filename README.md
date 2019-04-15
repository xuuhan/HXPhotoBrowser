# HXPhotoBrowser

* A picture browser that simulates progressive loading

* Based on SDWebImage

# Language

Objective-C

# CocoaPods



# Example

* fade in list

```
#import "HXUIButton+SDWebImage.h" or import "HXUIImageView+SDWebImage.h"

- (void)sd_setFadeImageWithURL:(nullable NSURL *)url;
```

![image](https://github.com/xuuhan/HXPhotoBrowser/blob/master/Example/list.gif?raw=true)

* style in photoBrowser

```
typedef NS_ENUM(NSUInteger, HXPhotoLoadType) {
    HXPhotoLoadTypeNormal = 0,
    HXPhotoLoadTypeMask,
    HXPhotoLoadTypeProgressive
};

typedef NS_ENUM(NSUInteger, HXPhotoProgressType) {
    HXPhotoProgressTypeRing = 0,
    HXPhotoProgressTypeBar
};
```
