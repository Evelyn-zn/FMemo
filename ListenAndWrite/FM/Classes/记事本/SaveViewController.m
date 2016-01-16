//
//  SaveViewController.m
//  FM
//
//  Created by lanou3g on 15/12/1.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import "SaveViewController.h"

@interface SaveViewController ()
@end

@implementation SaveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.saveValues;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    int index = (int)indexPath.row;
    NSString *str = [NSString stringWithFormat:@"备忘录-文本%d",index + 1];
    cell.textLabel.text = str;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 获取数据库中数据
    NSString *document = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath = [document stringByAppendingPathComponent:@"备忘录"];
    NSString *savePath = [filePath stringByAppendingPathComponent:@"TEXT.sqlite"];

    if ([[NSFileManager defaultManager]fileExistsAtPath:savePath]) {
        FMDatabase *dataBase = [FMDatabase databaseWithPath:savePath];
        if ([dataBase open]) {
            FMResultSet *result = [dataBase executeQuery:@"SELECT * FROM save"];
            while ([result next]) {
                NSInteger ID = [result intForColumn:@"ID"];
                if (ID == (indexPath.row + 1)) {
                    NSString *data = [result stringForColumn:@"data"];
                    TextZSSRichTextEditor *textVC = [[TextZSSRichTextEditor alloc] init];
                    textVC.data = data;
                    textVC.title = @"备忘录";
                    textVC.view.backgroundColor = [UIColor whiteColor];
                    UIImageView *imV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"700_10.jpeg"]];
                    imV.frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 40);
                    [textVC.view addSubview:imV];
                    imV.alpha = 0.15;
                    [self.navigationController pushViewController:textVC animated:YES];
                }
            }
        }
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [UIScreen mainScreen].bounds.size.height / 12;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}















- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
