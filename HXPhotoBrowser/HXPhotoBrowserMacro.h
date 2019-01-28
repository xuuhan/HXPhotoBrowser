//
//  HXPhotoBrowserMacro.h
//  HXPhotoBrowser
//
//  Created by suin on 2018/8/17.
//  Copyright © 2018年 韩旭. All rights reserved.
//
#ifndef HXPhotoBrowserMacro_h
#define HXPhotoBrowserMacro_h

#define kHXSCREEN_WIDTH    [[UIScreen mainScreen] bounds].size.width
#define kHXSCREEN_HEIGHT   [[UIScreen mainScreen] bounds].size.height

///zoom
static CGFloat const kHXPhotoBrowserZoomMin = 1.0;
static CGFloat const kHXPhotoBrowserZoomMid = 2.0;
static CGFloat const kHXPhotoBrowserZoomMax = 3.0;

///transform
static CGFloat const kHXPhotoBrowserTransformShrink = 0.995;
static CGFloat const kHXPhotoBrowserTransformAmplify = 1.005;
static CGFloat const kHXPhotoBrowserDisMissValue = 0.5;

///process
static CGFloat const kHXPhotoBrowserProcessHeight = 3.5;

///margin
static CGFloat const kHXPhotoBrowserPageMargin = 15;

#endif
