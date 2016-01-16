//
//  ListenDetailViewController.h
//  FM
//
//  Created by lanou3g on 15/11/28.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AlbumDetailModel;
#pragma mark = = = = = 播放界面

@interface ListenDetailViewController : UIViewController

#pragma - - - - - ***** 1. 界面传值
@property (assign,nonatomic) NSInteger page;
// 接收点击集合视图cell的下标
@property (assign,nonatomic) NSInteger index;
@property (strong,nonatomic) NSMutableArray *String;

#pragma mark 1. 榜单0所需数据：
@property (strong,nonatomic) programModel *modelPro; // page为0时
@property (strong,nonatomic) NSMutableArray *arrayModel; // 接收page0


#pragma mark 2. 榜单1和2所需数据：
@property (strong,nonatomic) AlbumModel *modelAL; // page为1 2时
@property (strong,nonatomic) AlbumDetailModel *modelDetailAL;
@property (strong,nonatomic) NSMutableArray *arraySecond; // 接收page1 2中的所有集数
// 接收tableView中点击cell的下标（第多少集）
@property (assign,nonatomic) NSInteger indexSecond;



#pragma - - - - - ***** 2. 控件
@property (weak, nonatomic) IBOutlet UIImageView *albumImageView;

@property (weak, nonatomic) IBOutlet UILabel *nickName;

@property (weak, nonatomic) IBOutlet UILabel *albumName;

@property (weak, nonatomic) IBOutlet UILabel *introText;

@property (weak, nonatomic) IBOutlet UILabel *titleCurrent;
@property (weak, nonatomic) IBOutlet UIView *viewScroll;


// 按钮：

@property (weak, nonatomic) IBOutlet UIButton *playButton;

@end
