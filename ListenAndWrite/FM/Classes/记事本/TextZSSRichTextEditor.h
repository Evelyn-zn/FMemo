//
//  TextZSSRichTextEditor.h
//  FM
//
//  Created by lanou3g on 15/11/30.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDatabase.h"
#import "SaveViewController.h"

@interface TextZSSRichTextEditor : ZSSRichTextEditor<UITextViewDelegate>

@property (strong,nonatomic) FMDatabase *db;

@property (assign,nonatomic) NSInteger index;
@property (assign,nonatomic) NSInteger valuesOfText;
@property (strong,nonatomic) NSString *textInput;
@property (strong,nonatomic) NSString *data;


@property (strong,nonatomic) NSUserDefaults *userDefaults;
@end
