//
//  AlbumModel.h
//  FM
//
//  Created by lanou3g on 15/11/27.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlbumModel : NSObject

#pragma mark 榜单1 2：的Model类

@property (strong,nonatomic) NSString *title;
@property (assign,nonatomic) NSInteger tracksCounts; // 集数
@property (strong,nonatomic) NSString *tags; // 标签
@property (strong,nonatomic) NSString *coverMiddle; // 图片
@property (strong,nonatomic) NSString *intro;// 简介
@property (strong,nonatomic) NSString *nickname; // 来源

@property (assign,nonatomic) NSInteger albumId;

@end
