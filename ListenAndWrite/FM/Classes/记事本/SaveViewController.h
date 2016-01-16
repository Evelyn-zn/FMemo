//
//  SaveViewController.h
//  FM
//
//  Created by lanou3g on 15/12/1.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import "ZSSRichTextEditor.h"
#import "FMDatabase.h"
@interface SaveViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (assign,nonatomic) NSInteger saveValues;

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end
