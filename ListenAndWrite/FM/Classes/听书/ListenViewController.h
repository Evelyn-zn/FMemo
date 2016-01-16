//
//  ListenViewController.h
//  FM
//
//  Created by lanou3g on 15/11/26.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
@interface ListenViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property (strong,nonatomic) NSMutableArray *listArray;
@property (strong,nonatomic) NSMutableArray *listResultArray;


@property (strong,nonatomic) Reachability *reachability;

@end
