//
//  DemoViewController.m
//  HXPhotoBrowser
//
//  Created by suin on 2018/8/13.
//  Copyright © 2018年 韩旭. All rights reserved.
//

#import "DemoViewController.h"
#import "UIImageView+SDWebImage.h"
#import "UIButton+SDWebImage.h"
#import "HXPhotoBrowserViewController.h"


@interface DemoViewController ()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIButton *imgBtn;
@property (nonatomic, strong) NSArray *urlImgArray;
@property (nonatomic, strong) NSArray *thumbUrlImgArray;
@end

@implementation DemoViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"清除缓存" style:UIBarButtonItemStyleDone target:self action:@selector(cleanMemory)];
    self.navigationItem.rightBarButtonItem = rightItem;
}


/**
 加载图片
 */
- (void)setIndex:(NSInteger)index{
    
    [self setDemoTitle:@"单图"];
    _imgBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 114, 150, 150)];
    [self.view addSubview:_imgBtn];
    _imgBtn.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1];
    _imgBtn.adjustsImageWhenHighlighted = NO;
    [_imgBtn addTarget:self action:@selector(showPhotoBrows:) forControlEvents:UIControlEventTouchUpInside];
    _imgBtn.tag = 0;
    
    [self setDemoTitle:@"多图"];
    CGFloat wh = 80;
    CGFloat x =  15;
    CGFloat margin = ([UIScreen mainScreen].bounds.size.width - 4 * 80 - x * 2) / 3;
    
    if (index == 0) {///加载本地图片
        self.title = @"本地图片";
        
    } else if (index == 1){///加载网络图片
        self.title = @"网络图片";
        [_imgBtn sd_setFadeBackgroundImageWithURL:[NSURL URLWithString:self.thumbUrlImgArray[0]] forState:UIControlStateNormal];
        
        for (int i = 0 ; i < 8; i ++) {
            int indexX = i % 4;
            int indexY = i / 4;
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(x + indexX  * (wh + margin), 314 + indexY * (wh + 15), wh, wh)];
            [self.view addSubview:btn];
            btn.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1];
            btn.tag = i + 1;
            [btn sd_setFadeImageWithURL:[NSURL URLWithString:self.thumbUrlImgArray[i + 1]] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(showPhotoBrows:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}

/**
 展示photobrowser
 */
- (void)showPhotoBrows:(UIButton *)sender{
    HXPhotoBrowserViewController *pb = [HXPhotoBrowserViewController new];
    pb.parentVC = self;
    pb.selectedView = sender;
    pb.urlStrArray = @[self.urlImgArray[sender.tag]];
    [pb show];
}

- (void)setDemoTitle:(NSString *)title{
    UILabel *label = [UILabel new];
    [self.view addSubview:label];
    label.frame = [title isEqualToString:@"单图"] ? CGRectMake(15, 79, [UIScreen mainScreen].bounds.size.width - 30, 20) : CGRectMake(15, 279, 100, 20);
    label.textColor = self.view.tintColor;
    label.font = [UIFont systemFontOfSize:15];
    label.text = title;
}

/**
 清除缓存
 */
- (void)cleanMemory{
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
    
    [[SDImageCache sharedImageCache] clearMemory];
}


- (NSArray *)urlImgArray{
    if (!_urlImgArray) {
        _urlImgArray = @[@"https://timgsa.baidu.com/timg?image&quality=80&size=b99999_100000&sec=1534944618413&di=c23d3fb9220505e401dc01c5e77e58ce&imgtype=0&src=http%3A%2F%2Fattach.bbs.miui.com%2Fforum%2F201311%2F20%2F210652i7055pz2cpgptgqu.jpg",
                         @"https://timgsa.baidu.com/timg?image&quality=80&size=b99999_100000&sec=1534159043230&di=29291766eb7a26fc35101c4c70576f1b&imgtype=0&src=http%3A%2F%2Fh.hiphotos.baidu.com%2Fzhidao%2Fpic%2Fitem%2F6f061d950a7b020894413af561d9f2d3572cc81e.jpg",
                         @"https://timgsa.baidu.com/timg?image&quality=80&size=b99999_100000&sec=1534159043230&di=1f22dfb9c7e235cbc5275a5f7601aa2c&imgtype=0&src=http%3A%2F%2Fbpic.ooopic.com%2F16%2F27%2F08%2F16270869-23884bc31e8305a7b162782d699071b5-1.jpg",
                         @"https://timgsa.baidu.com/timg?image&quality=80&size=b99999_100000&sec=1534159043229&di=2ad51c6773a4ae5fbe6c5ddb87dc40f7&imgtype=0&src=http%3A%2F%2Fimg02.tooopen.com%2Fimages%2F20150626%2Ftooopen_sy_131975725283.jpg",
                         @"https://timgsa.baidu.com/timg?image&quality=80&size=b99999_100000&sec=1534159043229&di=05d913fbe11fbe3386fcb39b90874fa3&imgtype=0&src=http%3A%2F%2Fpic17.photophoto.cn%2F20101126%2F0040039332126348_b.jpg",
                         @"https://timgsa.baidu.com/timg?image&quality=80&size=b99999_100000&sec=1534159043229&di=597328e29d41331e0b98dddc761f5e3e&imgtype=0&src=http%3A%2F%2Fpic8.nipic.com%2F20100810%2F3320946_213230051035_2.jpg",
                         @"https://timgsa.baidu.com/timg?image&quality=80&size=b99999_100000&sec=1534159043227&di=898b792c625ed46e3de40cc10a9befbb&imgtype=0&src=http%3A%2F%2Fimg005.hc360.cn%2Fy5%2FM00%2F74%2F9F%2FwKhQUVXK_4iEKhW1AAAAAOfwJvQ190.jpg",
                         @"https://timgsa.baidu.com/timg?image&quality=80&size=b99999_100000&sec=1535026488310&di=5dc2efdd8236d44695e5e25c585680ed&imgtype=jpg&src=http%3A%2F%2Fimg1.imgtn.bdimg.com%2Fit%2Fu%3D2130241891%2C1316613733%26fm%3D214%26gp%3D0.jpg",
                         @"https://timgsa.baidu.com/timg?image&quality=80&size=b99999_100000&sec=1535026643213&di=c5f021b3b024e4fb51822f1666caf7be&imgtype=0&src=http%3A%2F%2Fww1.sinaimg.cn%2Fmw690%2F0065nkS7jw1eziwwjz5jwj30c80lqgo0.jpg"];
    }
    return _urlImgArray;
}

- (NSArray *)thumbUrlImgArray{
    if (!_thumbUrlImgArray) {
        _thumbUrlImgArray = @[@"https://timgsa.baidu.com/timg?image&quality=80&size=b1999_2000&sec=1534944618413&di=c23d3fb9220505e401dc01c5e77e58ce&imgtype=0&src=http%3A%2F%2Fattach.bbs.miui.com%2Fforum%2F201311%2F20%2F210652i7055pz2cpgptgqu.jpg",
                              @"https://timgsa.baidu.com/timg?image&quality=80&size=b1999_2000&sec=1534159043230&di=29291766eb7a26fc35101c4c70576f1b&imgtype=0&src=http%3A%2F%2Fh.hiphotos.baidu.com%2Fzhidao%2Fpic%2Fitem%2F6f061d950a7b020894413af561d9f2d3572cc81e.jpg",
                              @"https://timgsa.baidu.com/timg?image&quality=80&size=b1999_2000&sec=1534159043230&di=1f22dfb9c7e235cbc5275a5f7601aa2c&imgtype=0&src=http%3A%2F%2Fbpic.ooopic.com%2F16%2F27%2F08%2F16270869-23884bc31e8305a7b162782d699071b5-1.jpg",
                              @"https://timgsa.baidu.com/timg?image&quality=80&size=b1999_2000&sec=1534159043229&di=2ad51c6773a4ae5fbe6c5ddb87dc40f7&imgtype=0&src=http%3A%2F%2Fimg02.tooopen.com%2Fimages%2F20150626%2Ftooopen_sy_131975725283.jpg",
                              @"https://timgsa.baidu.com/timg?image&quality=80&size=b1999_2000&sec=1534159043229&di=05d913fbe11fbe3386fcb39b90874fa3&imgtype=0&src=http%3A%2F%2Fpic17.photophoto.cn%2F20101126%2F0040039332126348_b.jpg",
                              @"https://timgsa.baidu.com/timg?image&quality=80&size=b1999_2000&sec=1534159043229&di=597328e29d41331e0b98dddc761f5e3e&imgtype=0&src=http%3A%2F%2Fpic8.nipic.com%2F20100810%2F3320946_213230051035_2.jpg",
                              @"https://timgsa.baidu.com/timg?image&quality=80&size=b1999_2000&sec=1534159043227&di=898b792c625ed46e3de40cc10a9befbb&imgtype=0&src=http%3A%2F%2Fimg005.hc360.cn%2Fy5%2FM00%2F74%2F9F%2FwKhQUVXK_4iEKhW1AAAAAOfwJvQ190.jpg",
                              @"https://timgsa.baidu.com/timg?image&quality=80&size=b1999_2000&sec=1535026488310&di=5dc2efdd8236d44695e5e25c585680ed&imgtype=jpg&src=http%3A%2F%2Fimg1.imgtn.bdimg.com%2Fit%2Fu%3D2130241891%2C1316613733%26fm%3D214%26gp%3D0.jpg",
                              @"https://timgsa.baidu.com/timg?image&quality=80&size=b1999_2000&sec=1535026643213&di=c5f021b3b024e4fb51822f1666caf7be&imgtype=0&src=http%3A%2F%2Fww1.sinaimg.cn%2Fmw690%2F0065nkS7jw1eziwwjz5jwj30c80lqgo0.jpg"];
    }
    return _thumbUrlImgArray;
}
@end
