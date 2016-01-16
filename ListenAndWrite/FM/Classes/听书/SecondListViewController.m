//
//  SecondListViewController.m
//  FM
//
//  Created by lanou3g on 15/11/28.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import "SecondListViewController.h"

@interface SecondListViewController ()

{
    NSMutableArray *arrayURL;
    
}

@end

@implementation SecondListViewController
{
    int value;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageValue = 0; // 初始化
    self.page = 1;
    value = 0;
    [self setViews];
    
    
    [self setDelegate];
    
    [self getData];
    [self load];
}


#pragma mark UICollectionView 上下拉刷新
- (void)load {
    __unsafe_unretained __typeof(self) weakSelf = self;
    // 下拉刷新
    self.tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
    }];
    [self.tableView.mj_header beginRefreshing];
    
    // 上拉刷新
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (value < arrayURL.count) {
            [DataDetailRequest GetDetailData:arrayURL[value] block:^(NSData *data, NSInteger value) {
                [self JSONData:data];
                [self.tableView reloadData];
            }];
            value ++;
        }
        [weakSelf.tableView reloadData];
        // 结束刷新
        [weakSelf.tableView.mj_footer endRefreshing];
        // 刷新完全部数据 设置刷新状态：MJRefreshStateNoMoreData 不再加载
        if (value > arrayURL.count) {
            
        }
    }];
    // 默认先隐藏footer
    self.tableView.mj_footer.hidden = YES;
}

#pragma mark = = = = = = = = 1. 设置基本的初始化：控件及变量
- (void)setViews {
    // 初始化属性arrayModel
    self.arrayModel = [[NSMutableArray alloc] init];
    
    self.titleName.text = self.modelAlB.title;
    self.albumTitle.text = self.modelAlB.nickname;
    
    
    CGRect rect = self.introLabel.frame;
    rect.size.height = [self getLabelHeight:self.introLabel.text];
    self.introLabel.frame = rect;
    self.introLabel.text = self.modelAlB.intro;
    
    [self.albumImageView sd_setImageWithURL:[NSURL URLWithString:self.modelAlB.coverMiddle]];
    if (self.modelAlB.tracksCounts % 20 != 0) {
        self.pageValue += 1;
    }
    self.pageValue += self.modelAlB.tracksCounts / 20;
}

#pragma mark = = = = = = = = 2. 设置代理：tableView
- (void)setDelegate {
    self.tableView.dataSource = self;
    self.tableView.dataSource = self;
}

#pragma mark = = = = = = = = 3. 解析数据
- (void)getData {
    
    // 先解析第一页数据：20个  然后每次刷新再继续增加20个
    NSString *string = [NSString stringWithFormat:Detail_URL, (long)self.modelAlB.albumId, 1, (long)self.modelAlB.albumId];
    [DataRequest GetListData:string block:^(NSData * data) {
        [self JSONData:data];
        [self.tableView reloadData];
    }];
    // 将每一页的URL存到数组里 等待网络请求 加载
    arrayURL = [[NSMutableArray alloc] init];
    for (int i = 2; i <= self.pageValue; i++) {
        NSString *str = [NSString stringWithFormat:Detail_URL, (long)self.modelAlB.albumId, i, (long)self.modelAlB.albumId];
        [arrayURL addObject:str];
    }
    
}

- (void)JSONData:(NSData *)data {
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:0];
    NSMutableArray *array = [dic[@"tracks"] objectForKey:@"list"];
    for (NSDictionary *dictionary in array) {
        AlbumDetailModel *model = [[AlbumDetailModel alloc] init];
        [model setValuesForKeysWithDictionary:dictionary];
        [self.arrayModel addObject:model];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayModel.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"list_cell_id" forIndexPath:indexPath];
    
    AlbumDetailModel *model = self.arrayModel[indexPath.row];
    cell.textLabel.text = model.title;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    return cell;
}

/*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"选中：%ld", indexPath.row);
    
    
    UIStoryboard *storyPlay = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    ListenDetailViewController *PlayerVC = [storyPlay instantiateViewControllerWithIdentifier:@"detail_id"];
    PlayerVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    // 跳转前  先传值：
    PlayerVC.modelAL = self.modelAlB;
    PlayerVC.arraySecond = self.arrayModel;
    [self presentViewController:PlayerVC animated:YES completion:nil];
}
 */


// 按钮点击返回

- (IBAction)backButton:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark  计算label文字高度
- (CGFloat)getLabelHeight:(NSString *)string {
    CGSize size = CGSizeMake(232, 1000);
    NSDictionary *dic = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:17] forKey:NSFontAttributeName];
    
    CGRect rect =  [string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    return rect.size.height;
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Second_segue"]) {
        ListenDetailViewController *PlayerVC = (ListenDetailViewController *)segue.destinationViewController;
        PlayerVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        NSIndexPath *index = [self.tableView indexPathForSelectedRow];
        
        PlayerVC.indexSecond = index.row;
        PlayerVC.modelAL = self.modelAlB;
        PlayerVC.arraySecond = self.arrayModel;
        PlayerVC.page = 1;
        PlayerVC.arrayModel = self.allData;
        PlayerVC.index = self.index;
        PlayerVC.String = self.arrayString;
        for (NSString *str in self.arrayString) {
            NSLog(@"*** %@", str);
        }
        
    }
}


@end
