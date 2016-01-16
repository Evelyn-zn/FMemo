//
//  SecondListViewController.h
//  FM
//
//  Created by lanou3g on 15/11/28.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

#pragma 界面传值
@property (strong,nonatomic) AlbumModel *modelAlB;
@property (assign,nonatomic) NSInteger page;
@property (strong,nonatomic) NSMutableArray *arrayModel; // list中：每个节目的数组  所有集数
@property (assign,nonatomic) NSInteger pageValue; // 每个选项里面包含多少页（很据集数计算 返回）
@property (assign,nonatomic) NSInteger index;
@property (strong,nonatomic) NSMutableArray *allData;
// 标签传值
@property (strong,nonatomic) NSMutableArray *arrayString;





@property (weak, nonatomic) IBOutlet UILabel *titleName;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIImageView *albumImageView;

@property (weak, nonatomic) IBOutlet UILabel *albumTitle;
@property (weak, nonatomic) IBOutlet UILabel *introLabel;

@end
