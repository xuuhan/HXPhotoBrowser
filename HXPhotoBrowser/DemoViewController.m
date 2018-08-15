//
//  DemoViewController.m
//  HXPhotoBrowser
//
//  Created by suin on 2018/8/13.
//  Copyright © 2018年 韩旭. All rights reserved.
//

#import "DemoViewController.h"
#import "UIImageView+SDWebImage.h"


@interface DemoViewController ()
@property (nonatomic, strong) UIImageView *img;
@property (nonatomic, strong) NSArray *urlImgArray;
@end

@implementation DemoViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"清除缓存" style:UIBarButtonItemStyleDone target:self action:@selector(cleanMemory)];
    
    self.navigationItem.rightBarButtonItem = rightItem;
}


- (void)setIndex:(NSInteger)index{
    
    _img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 200)];
    [self.view addSubview:_img];
    _img.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1];
    
    if (index == 0) {///加载本地图片
        self.title = @"本地图片";
        
    } else if (index == 1){///加载网络图片
        self.title = @"网络图片";
        [_img sd_setFadeImageWithURL:[NSURL URLWithString:self.urlImgArray[0]]];
    }
}

- (void)cleanMemory{
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
    
    [[SDImageCache sharedImageCache] clearMemory];
}

- (NSArray *)urlImgArray{
    if (!_urlImgArray) {
        _urlImgArray = @[@"http://img.pconline.com.cn/images/upload/upc/tx/wallpaper/1607/05/c0/23802963_1467729409855.jpg",
                         @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1534159043230&di=29291766eb7a26fc35101c4c70576f1b&imgtype=0&src=http%3A%2F%2Fh.hiphotos.baidu.com%2Fzhidao%2Fpic%2Fitem%2F6f061d950a7b020894413af561d9f2d3572cc81e.jpg",
                         @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1534159043230&di=1f22dfb9c7e235cbc5275a5f7601aa2c&imgtype=0&src=http%3A%2F%2Fbpic.ooopic.com%2F16%2F27%2F08%2F16270869-23884bc31e8305a7b162782d699071b5-1.jpg",
                         @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1534159043229&di=2ad51c6773a4ae5fbe6c5ddb87dc40f7&imgtype=0&src=http%3A%2F%2Fimg02.tooopen.com%2Fimages%2F20150626%2Ftooopen_sy_131975725283.jpg",
                         @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1534159043229&di=05d913fbe11fbe3386fcb39b90874fa3&imgtype=0&src=http%3A%2F%2Fpic17.photophoto.cn%2F20101126%2F0040039332126348_b.jpg",
                         @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1534159043229&di=597328e29d41331e0b98dddc761f5e3e&imgtype=0&src=http%3A%2F%2Fpic8.nipic.com%2F20100810%2F3320946_213230051035_2.jpg",
                         @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1534159043227&di=898b792c625ed46e3de40cc10a9befbb&imgtype=0&src=http%3A%2F%2Fimg005.hc360.cn%2Fy5%2FM00%2F74%2F9F%2FwKhQUVXK_4iEKhW1AAAAAOfwJvQ190.jpg"];
    }
    return _urlImgArray;
}
@end
