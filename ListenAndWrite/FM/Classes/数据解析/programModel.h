//
//  programModel.h
//  FM
//
//  Created by lanou3g on 15/11/26.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface programModel : NSObject


#pragma mark 榜单0： 的Model类

@property (strong,nonatomic) NSString *title;
@property (strong,nonatomic) NSString *nickname;// 来源
@property (strong,nonatomic) NSString *tags; // 标签
@property (strong,nonatomic) NSString *albumTitle; // 专辑

@property (strong,nonatomic) NSString *playPathAacv224;// 音质
@property (strong,nonatomic) NSString *coverSmall; // 图片

@end
