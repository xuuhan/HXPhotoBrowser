# HXPhotoBrowser

* A photo browser that simulates progressive loading

* Based on SDWebImage

# Language

Objective-C

# Example

* fade in list

```
#import "HXUIButton+SDWebImage.h" or #import "HXUIImageView+SDWebImage.h"

- (void)sd_setFadeImageWithURL:(nullable NSURL *)url;
```

![image](https://github.com/xuuhan/HXPhotoBrowser/blob/master/Example/list.gif?raw=true)

* style in photoBrowser

```
typedef NS_ENUM(NSUInteger, HXPhotoLoadType) {
    HXPhotoLoadTypeNormal = 0, //正常样式
    HXPhotoLoadTypeMask, //遮罩层样式
    HXPhotoLoadTypeProgressive //渐进式加载样式
};

typedef NS_ENUM(NSUInteger, HXPhotoProgressType) {
    HXPhotoProgressTypeRing = 0, //圆环网络加载进度
    HXPhotoProgressTypeBar //条状网络加载进度
};
```
![image](https://github.com/xuuhan/HXPhotoBrowser/blob/master/Example/1.gif?raw=true)
![image](https://github.com/xuuhan/HXPhotoBrowser/blob/master/Example/2.gif?raw=true)
![image](https://github.com/xuuhan/HXPhotoBrowser/blob/master/Example/3.gif?raw=true)
![image](https://github.com/xuuhan/HXPhotoBrowser/blob/master/Example/4.gif?raw=true)

# Use

```
HXPhotoBrowserViewController *pb = [HXPhotoBrowserViewController new];
pb.parentVC = self;
pb.photoViewArray = _selectedViewArray.copy;
pb.currentIndex = sender.tag;
pb.urlStrArray = self.urlImgArray;
pb.config.photoLoadType = HXPhotoLoadTypeMask;
pb.config.photoProgressType = HXPhotoProgressTypeRing;
[pb show];
```

## License

`HXPhotoBrowser` is available under the MIT license. See the LICENSE file for more info.
