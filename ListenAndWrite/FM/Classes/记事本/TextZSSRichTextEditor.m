//
//  TextZSSRichTextEditor.m
//  FM
//
//  Created by lanou3g on 15/11/30.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import "TextZSSRichTextEditor.h"

@implementation TextZSSRichTextEditor

- (void)viewDidLoad {
    [super viewDidLoad];
    self.valuesOfText = 0;// 文本个数
    NSString *html = @"请输入存储文本";
    self.baseURL = [NSURL URLWithString:@"http://www.zedsaid.com"];
    self.formatHTML = YES;
    if (self.data == nil) {
        [self setHtml:html];
    }else
        [self setHtml:self.data];
}

- (void)showInsertURLAlternatePicker {
    
    [self dismissAlertView];
    
    ZSSDemoPickerViewController *picker = [[ZSSDemoPickerViewController alloc] init];
    picker.demoView = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:picker];
    nav.navigationBar.translucent = NO;
    [self presentViewController:nav animated:YES completion:nil];
    
}



- (void)showInsertImageAlternatePicker {
    
    [self dismissAlertView];
    
    ZSSDemoPickerViewController *picker = [[ZSSDemoPickerViewController alloc] init];
    picker.demoView = self;
    picker.isInsertImagePicker = YES;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:picker];
    nav.navigationBar.translucent = NO;
    [self presentViewController:nav animated:YES completion:nil];
    
}

- (void)exportHTML {
}

- (IBAction)saveTextOfInput:(UIBarButtonItem *)sender {
    NSString *text = [self getHTML];
#pragma mark  * 分解/提取 用户输入的内容
    /*
    NSMutableArray *arrayInput = [[NSMutableArray alloc] init];
    
    NSArray *a = [S componentsSeparatedByString:@"&"];
    NSLog(@"%@", a);
    
    if (a.count >= 1) {
        NSString *string = [a firstObject];
        NSMutableArray *array = (NSMutableArray *)[string componentsSeparatedByString:@">"];
        
        NSLog(@"数组：%@", array);
        
        for (NSString *str2 in array) {
            if (![str2 isEqualToString:@""]) {
                if ([[str2 substringToIndex:1]isEqualToString:@"<"] || [[str2 substringToIndex:2]isEqualToString:@"\n"]) {
                    [array removeObject:str2];
                }else if ([str2 containsString:@"<"]){
                    NSMutableArray *a1 = (NSMutableArray *)[str2 componentsSeparatedByString:@"<"];
                    [arrayInput addObject:a1.firstObject];
                }else {
                    [arrayInput addObject:str2];
                }
            } 
        }
    }else {
        [arrayInput addObjectsFromArray:a];
    }
    
    NSLog(@"用户输入：%@", arrayInput);
     */
#pragma mark ** 储存用户输入的文件：
    NSString *document = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSLog(@"文件储存路径：%@", document);
    NSString *filePath = [document stringByAppendingPathComponent:@"备忘录"];
    NSString *savePath = [filePath stringByAppendingPathComponent:@"TEXT.sqlite"];
    
    if (![[NSFileManager defaultManager]fileExistsAtPath:savePath]) {
        NSFileManager *manager = [NSFileManager defaultManager];
        [manager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
        self.db = [FMDatabase databaseWithPath:savePath];
        if ([self.db open]) {
            [self.db executeUpdate:@"CREATE TABLE IF NOT EXISTS save (id integer PRIMARY KEY AUTOINCREMENT, data text NOT NULL)"];
        }else {
            NSLog(@"打开失败");
        }
    }else {
        self.index = 0;
        self.db = [FMDatabase databaseWithPath:savePath];
        [self.db open];
        FMResultSet *result = [self.db executeQuery:@"SELECT * FROM save"];
        while ([result next]){
            // 之前数据库中文件数
            self.index += 1;
        }
    }
    [self insert:text];
    [self.db close];
    
}
- (void)insert:(NSString *)data {
    if ([self.db executeUpdate:@"INSERT INTO save (data) VALUES (?)", data]) {
        NSLog(@"添加数据成功");
        self.index += 1;
    }else {
        NSLog(@"添加数据失败");
    }
}

//- (NSInteger)getMark {
//    int mark = 0;
//    FMResultSet *result = [self.db executeQuery:@"SELECT * FROM save"];
//    while ([result next]) {
//        NSString *name = [result stringForColumn:@"name"];
//        int nameIndex = [name intValue];
//        if (nameIndex == self.index)
//            mark = 1;
//    }
//    return mark;
//}
//
//
//
//- (void)dataUpdate:(NSString *)data {
//      NSString *string = [NSString  stringWithFormat:@"%d", self.index];
//    if ([self.db executeUpdate:@"UPDATE save SET data = ? WHERE name = ?", data, string ]) {
//        NSLog(@"修改数据成功");
//    }else
//        NSLog(@"修改数据失败");
//    
//}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"segue_save"]) {
        SaveViewController *saveVC = (SaveViewController *)segue.destinationViewController;
        saveVC.saveValues = self.index;
    }else {
        NSLog(@"ERROR! !  ! !  ");
    }
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
