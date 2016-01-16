//
//  ListenViewController.m
//  FM
//
//  Created by lanou3g on 15/11/26.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import "ListenViewController.h"
#import "AppDelegate.h"
@interface ListenViewController ()

@end

@implementation ListenViewController

- (void)JSONData:(NSData *)data {
    self.listArray = [[NSMutableArray alloc] init];
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSDictionary *dictionary = [dic[@"datas"] firstObject];
    for (NSDictionary *d in dictionary[@"list"]) {
        ListDataModel *model = [[ListDataModel alloc] init];
        [model setValuesForKeysWithDictionary:d];

        NSArray *arr = model.firstKResults;
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *d in arr) {
            
            ListResultDataModel *modelL = [[ListResultDataModel alloc
                                            ] init];
            [modelL setValuesForKeysWithDictionary:d];
            [array addObject:modelL];
        }
        model.firstKResults = array;
        [self.listArray addObject:model];
    }
}



- (void)viewDidLoad {
    [super viewDidLoad];

    // 设置通知
    [self setNotification];
}


#pragma mark - 监测网络连接
- (void)setNotification {
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reachabilityChanged1:) name:kReachabilityChangedNotification object:nil];
    
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    
    [reach startNotifier];
}

-(void)reachabilityChanged1:(NSNotification*)notification {
    
    Reachability *currentReach = [notification object];
    NSParameterAssert([currentReach isKindOfClass:[Reachability class]]);
    NetworkStatus status = [currentReach currentReachabilityStatus];
    
    if(status == NotReachable) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示:" message:@"网络连接失败，请检查网络" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"网络连接失败，请检查网络");
            
            // 数据重新加载
            
        }];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    } else if (status == ReachableViaWiFi||status == ReachableViaWWAN) {
        NSLog(@"YES");
        [self setData];
    }
}

- (void)setData {
    [DataRequest GetListData:RankingList_URL block:^(NSData *data) {
        [self JSONData:data];
        [self.tableView reloadData];
    }];
}

- (void)setDelegate {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ListenTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_id_listen" forIndexPath:indexPath];
    ListDataModel *model = self.listArray[indexPath.row];
    cell.listTitle.text = model.title;
    [cell.imageViewList sd_setImageWithURL:[NSURL URLWithString:model.coverPath]];
    
    NSMutableArray *a = [NSMutableArray array];
    for (ListResultDataModel *resultModel in model.firstKResults) {
        [a addObject:resultModel.title] ;
    }
    if (a.count <= 1) {
        cell.oneTitle.text = [NSString stringWithFormat:@"1.%@", a[0]];
        cell.twoTitle.text = [NSString stringWithFormat:@""];
        cell.threeTitle.text = [NSString stringWithFormat:@""];
    }else if (a.count <= 2) {
        cell.oneTitle.text = [NSString stringWithFormat:@"1.%@", a[0]];
        cell.twoTitle.text = [NSString stringWithFormat:@"2.%@", a[1]];
        cell.threeTitle.text = [NSString stringWithFormat:@""];
    } else {
        cell.oneTitle.text = [NSString stringWithFormat:@"1.%@", a[0]];
        cell.twoTitle.text = [NSString stringWithFormat:@"2.%@", a[1]];
        cell.threeTitle.text = [NSString stringWithFormat:@"3.%@", a[2]];
    }
    return cell;
}   







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"segue_list"]) {
        AWCollectionViewController *AWVC = (AWCollectionViewController *)segue.destinationViewController;
        NSIndexPath *index = [self.tableView indexPathForSelectedRow];
        AWVC.item = self.listArray[index.row];
        AWVC.page = index.row;
    }
}


@end
