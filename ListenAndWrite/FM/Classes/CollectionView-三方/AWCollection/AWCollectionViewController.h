//
//  AWCollectionViewController.h
//  FM
//
//  Created by lanou3g on 15/11/25.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import <UIKit/UIKit.h>





@interface AWCollectionViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *EditButton;


@property (weak, nonatomic) IBOutlet UICollectionView *CollectionLayout;

@property (strong,nonatomic) ListDataModel *item;

@property (strong,nonatomic) NSMutableArray *allData;
// page: 0 1 2第一页点击cell的下标
@property (assign,nonatomic) NSInteger page;

@property (assign,nonatomic) int PageID;// 获取解析数据页

@property (strong,nonatomic) NSData *listData;

@property (strong,nonatomic) NSMutableArray *arrayTags;

@end
