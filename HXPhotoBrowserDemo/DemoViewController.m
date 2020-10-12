//
//  DemoViewController.m
//  HXPhotoBrowser
//
//  Created by suin on 2018/8/13.
//  Copyright © 2018年 韩旭. All rights reserved.
//

#import "DemoViewController.h"
#import "HXUIImageView+SDWebImage.h"
#import "HXUIButton+SDWebImage.h"
#import "HXPhotoBrowserViewController.h"

@interface DemoViewController ()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIButton *imgBtn;
@property (nonatomic, strong) NSArray *singleUrlImgArray;
@property (nonatomic, strong) NSArray *singleThumbUrlImgArray;
@property (nonatomic, strong) NSArray *urlImgArray;
@property (nonatomic, strong) NSArray *thumbUrlImgArray;
@property (nonatomic, strong) NSMutableArray <UIView *>*selectedViewArray;
@end

@implementation DemoViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
}


/**
 加载图片
 */
- (void)setIndex:(NSInteger)index{
    
    [self setDemoTitle:@"单图"];
    _imgBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 135, 150, 150)];
    [self.view addSubview:_imgBtn];
    _imgBtn.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1];
    _imgBtn.adjustsImageWhenHighlighted = NO;
    [_imgBtn addTarget:self action:@selector(showPhotoBrows:) forControlEvents:UIControlEventTouchUpInside];
    _imgBtn.tag = 0;
    
    [self setDemoTitle:@"多图"];
    CGFloat wh = 80;
    CGFloat x =  15;
    CGFloat margin = ([UIScreen mainScreen].bounds.size.width - 4 * 80 - x * 2) / 3;
    
    _selectedViewArray = [NSMutableArray array];
    
    if (index == 0) {
        self.title = @"网络图片";
        [_imgBtn sd_setFadeBackgroundImageWithURL:[NSURL URLWithString:self.singleThumbUrlImgArray[0]] forState:UIControlStateNormal];
        
        for (int i = 0 ; i < self.thumbUrlImgArray.count; i ++) {
            int indexX = i % 4;
            int indexY = i / 4;
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(x + indexX  * (wh + margin), 335 + indexY * (wh + 15), wh, wh)];
            [self.view addSubview:btn];
            btn.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1];
            btn.tag = i;
            
            btn.imageView.contentMode = UIViewContentModeScaleAspectFill;
            [btn sd_setFadeImageWithURL:[NSURL URLWithString:self.thumbUrlImgArray[i]] forState:UIControlStateNormal];
            
            [btn addTarget:self action:@selector(showMultiplePhotoBrows:) forControlEvents:UIControlEventTouchUpInside];
            [_selectedViewArray addObject:btn];
        }
    }
}

/**
 展示photobrowser
 */

///单图
- (void)showPhotoBrows:(UIButton *)sender{
    HXPhotoBrowserViewController *pb = [HXPhotoBrowserViewController new];
    pb.parentVC = self;
    pb.photoViewArray = @[sender];
    pb.urlStrArray = @[self.singleUrlImgArray[0]];
    pb.config.photoLoadType = HXPhotoLoadTypeProgressive;
    pb.config.photoProgressType = HXPhotoProgressTypeBar;
    [pb show];
}

///多图
- (void)showMultiplePhotoBrows:(UIButton *)sender{
    HXPhotoBrowserViewController *pb = [HXPhotoBrowserViewController new];
    pb.parentVC = self;
    pb.photoViewArray = _selectedViewArray.copy;
    pb.currentIndex = sender.tag;
    pb.urlStrArray = self.urlImgArray;
    pb.config.photoLoadType = HXPhotoLoadTypeNormal;
    pb.config.photoProgressType = HXPhotoProgressTypeRing;
    [pb show];
}

- (void)setDemoTitle:(NSString *)title{
    UILabel *label = [UILabel new];
    [self.view addSubview:label];
    label.frame = [title isEqualToString:@"单图"] ? CGRectMake(15, 100, [UIScreen mainScreen].bounds.size.width - 30, 20) : CGRectMake(15, 300, 100, 20);
    label.textColor = self.view.tintColor;
    label.font = [UIFont systemFontOfSize:15];
    label.text = title;
}


- (NSArray *)singleUrlImgArray{
    if (!_singleUrlImgArray) {
        _singleUrlImgArray = @[@"https://timgsa.baidu.com/timg?image&quality=80&size=b99999_100000&sec=1534944618413&di=c23d3fb9220505e401dc01c5e77e58ce&imgtype=0&src=http%3A%2F%2Fattach.bbs.miui.com%2Fforum%2F201311%2F20%2F210652i7055pz2cpgptgqu.jpg"];
    }
    return _singleUrlImgArray;
}

- (NSArray *)urlImgArray{
    if (!_urlImgArray) {
        _urlImgArray = @[@"https://timgsa.baidu.com/timg?image&quality=80&size=b99999_100000&sec=1598176644349&di=0835fe381addd90694a3efea4c28abc6&imgtype=0&src=http%3A%2F%2Fpic1.win4000.com%2Fwallpaper%2F1%2F59bbc42a0133d.jpg%3Fdown",
                         @"https://timgsa.baidu.com/timg?image&quality=80&size=b99999_100000&sec=1535027780357&di=b92d5c61c2d47fc74c1fde73b26e0e0f&imgtype=0&src=http%3A%2F%2Fi5.3conline.com%2Fimages%2Fpiclib%2F201403%2F20%2Fbatch%2F1%2F218704%2F1395300904690g4dm91ubtq.jpg",
                         @"https://timgsa.baidu.com/timg?image&quality=80&size=b99999_100000&sec=1602500165539&di=81913a0b462bc6135cb2a4aeb811ec3e&imgtype=0&src=http%3A%2F%2Fimg1.pconline.com.cn%2Fpiclib%2F200811%2F17%2Fbatch%2F1%2F16797%2F1226885443432wk6gzq1nsd.jpg",
                         @"https://timgsa.baidu.com/timg?image&quality=80&size=b99999_100000&sec=1534159043229&di=05d913fbe11fbe3386fcb39b90874fa3&imgtype=0&src=http%3A%2F%2Fpic17.photophoto.cn%2F20101126%2F0040039332126348_b.jpg",
                         @"https://timgsa.baidu.com/timg?image&quality=80&size=b99999_100000&sec=1534159043229&di=597328e29d41331e0b98dddc761f5e3e&imgtype=0&src=http%3A%2F%2Fpic8.nipic.com%2F20100810%2F3320946_213230051035_2.jpg",
                         @"https://timgsa.baidu.com/timg?image&quality=80&size=b99999_100000&sec=1598176865248&di=3ebd46451bfbcc359e31e222e63fe553&imgtype=0&src=http%3A%2F%2Fimg.pconline.com.cn%2Fimages%2Fupload%2Fupc%2Ftx%2Fwallpaper%2F1209%2F17%2Fc0%2F13901631_1347858735837.jpg",
                         @"https://timgsa.baidu.com/timg?image&quality=80&size=b99999_100000&sec=1566474279233&di=e64f05b9709bc5e3596b902dba65782b&imgtype=0&src=http%3A%2F%2Fattach.bbs.miui.com%2Fforum%2F201310%2F16%2F224046ups8zp1jg31uz82g.jpg",
                         @"https://timgsa.baidu.com/timg?image&quality=80&size=b99999_100000&sec=1535026643213&di=c5f021b3b024e4fb51822f1666caf7be&imgtype=0&src=http%3A%2F%2Fww1.sinaimg.cn%2Fmw690%2F0065nkS7jw1eziwwjz5jwj30c80lqgo0.jpg",
                         @"https://timgsa.baidu.com/timg?image&quality=80&size=b99999_100000&sec=1548831044308&di=8ceae70ff5bec835e6b356dcd9d781c5&imgtype=0&src=http%3A%2F%2Fwx3.sinaimg.cn%2Forj360%2F007iuNxXly1fx4dlblfzxj31c94boqv5.jpg"];
    }
    return _urlImgArray;
}

- (NSArray *)singleThumbUrlImgArray{
    if (!_singleThumbUrlImgArray) {
        _singleThumbUrlImgArray = @[@"https://timgsa.baidu.com/timg?image&quality=80&size=b239_240&sec=1534944618413&di=c23d3fb9220505e401dc01c5e77e58ce&imgtype=0&src=http%3A%2F%2Fattach.bbs.miui.com%2Fforum%2F201311%2F20%2F210652i7055pz2cpgptgqu.jpg"];
    }
    return _singleThumbUrlImgArray;
}

- (NSArray *)thumbUrlImgArray{
    if (!_thumbUrlImgArray) {
        _thumbUrlImgArray = @[@"https://timgsa.baidu.com/timg?image&quality=80&size=b239_240&sec=1598176644349&di=0835fe381addd90694a3efea4c28abc6&imgtype=0&src=http%3A%2F%2Fpic1.win4000.com%2Fwallpaper%2F1%2F59bbc42a0133d.jpg%3Fdown",
                              @"https://timgsa.baidu.com/timg?image&quality=80&size=b239_240&sec=1535027780357&di=b92d5c61c2d47fc74c1fde73b26e0e0f&imgtype=0&src=http%3A%2F%2Fi5.3conline.com%2Fimages%2Fpiclib%2F201403%2F20%2Fbatch%2F1%2F218704%2F1395300904690g4dm91ubtq.jpg",
                              @"https://timgsa.baidu.com/timg?image&quality=80&size=b239_240&sec=1602500165539&di=81913a0b462bc6135cb2a4aeb811ec3e&imgtype=0&src=http%3A%2F%2Fimg1.pconline.com.cn%2Fpiclib%2F200811%2F17%2Fbatch%2F1%2F16797%2F1226885443432wk6gzq1nsd.jpg",
                              @"https://timgsa.baidu.com/timg?image&quality=80&size=b239_240&sec=1534159043229&di=05d913fbe11fbe3386fcb39b90874fa3&imgtype=0&src=http%3A%2F%2Fpic17.photophoto.cn%2F20101126%2F0040039332126348_b.jpg",
                              @"https://timgsa.baidu.com/timg?image&quality=80&size=b239_240&sec=1534159043229&di=597328e29d41331e0b98dddc761f5e3e&imgtype=0&src=http%3A%2F%2Fpic8.nipic.com%2F20100810%2F3320946_213230051035_2.jpg",
                              @"https://timgsa.baidu.com/timg?image&quality=80&size=b239_240&sec=1598176865248&di=3ebd46451bfbcc359e31e222e63fe553&imgtype=0&src=http%3A%2F%2Fimg.pconline.com.cn%2Fimages%2Fupload%2Fupc%2Ftx%2Fwallpaper%2F1209%2F17%2Fc0%2F13901631_1347858735837.jpg",
                              @"https://timgsa.baidu.com/timg?image&quality=80&size=b239_240&sec=1566474279233&di=e64f05b9709bc5e3596b902dba65782b&imgtype=0&src=http%3A%2F%2Fattach.bbs.miui.com%2Fforum%2F201310%2F16%2F224046ups8zp1jg31uz82g.jpg",
                              @"https://timgsa.baidu.com/timg?image&quality=80&size=b239_240&sec=1535026643213&di=c5f021b3b024e4fb51822f1666caf7be&imgtype=0&src=http%3A%2F%2Fww1.sinaimg.cn%2Fmw690%2F0065nkS7jw1eziwwjz5jwj30c80lqgo0.jpg",
                              @"https://timgsa.baidu.com/timg?image&quality=80&size=b239_240&sec=1548831044308&di=8ceae70ff5bec835e6b356dcd9d781c5&imgtype=0&src=http%3A%2F%2Fwx3.sinaimg.cn%2Forj360%2F007iuNxXly1fx4dlblfzxj31c94boqv5.jpg"];
    }
    return _thumbUrlImgArray;
}
@end
