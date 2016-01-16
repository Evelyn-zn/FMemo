//
//  ListDataModel.h
//  FM
//
//  Created by lanou3g on 15/11/26.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ListDataModel : NSObject

#pragma mark  首页显示三个榜单

@property (strong,nonatomic) NSString *title;
@property (strong,nonatomic) NSMutableArray *firstKResults;
@property (strong,nonatomic) NSString *coverPath; // 图片地址
@property (strong,nonatomic) NSString *key;
@property (strong,nonatomic) NSString *contentType;

@end
