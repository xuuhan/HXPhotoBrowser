//
//  ViewController.m
//  HXPhotoBrowser
//
//  Created by suin on 2018/8/10.
//  Copyright © 2018年 韩旭. All rights reserved.
//

#import "ViewController.h"
#import "DemoViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSArray *demoArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Demo列表";
    
    UITableView *tv = [[UITableView alloc] initWithFrame:self.view.frame];
    
    [self.view addSubview:tv];
    
    tv.delegate = self;
    tv.dataSource = self;
    
    
}

#pragma mark UITableViewDataSource UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.demoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    cell.textLabel.text = self.demoArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DemoViewController *demo = [[DemoViewController alloc] init];
    
    demo.index = indexPath.row;
    
    [self.navigationController pushViewController:demo animated:YES];
}

- (NSArray *)demoArray{
    if (!_demoArray) {
        _demoArray = @[@"本地图片",@"网络图片"];
    }
    return _demoArray;
}

@end
