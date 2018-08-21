//
//  HXPhotoBrowserMacro.h
//  HXPhotoBrowser
//
//  Created by suin on 2018/8/17.
//  Copyright © 2018年 韩旭. All rights reserved.
//

// UIScreenSize
#define SCREEN_WIDTH    [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT   [[UIScreen mainScreen] bounds].size.height

#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

// UIStatusBar
#define StatusBarHeight (iPhoneX ? 24.0f : 0.0f)

// zoom
#define kHXPhotoBrowserZoomMin 1.0
#define kHXPhotoBrowserZoomMid 2.0
#define kHXPhotoBrowserZoomMax 3.0

///transform
#define kHXPhotoBrowserTransformShrink 0.995
#define kHXPhotoBrowserTransformAmplify 1.005
#define kHXPhotoBrowserDisMissValue 0.5
